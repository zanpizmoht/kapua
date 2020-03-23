/*******************************************************************************
 * Copyright (c) 2017, 2019 Red Hat Inc and others.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Red Hat Inc - initial API and implementation
 *     Eurotech
 *******************************************************************************/
package org.eclipse.kapua.service.authentication.shiro.registration;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.ServiceLoader;

import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.locator.KapuaProvider;
import org.eclipse.kapua.security.registration.RegistrationProcessor;
import org.eclipse.kapua.security.registration.RegistrationProcessorProvider;
import org.eclipse.kapua.service.authentication.JwtCredentials;
import org.eclipse.kapua.service.authentication.registration.RegistrationService;
import org.eclipse.kapua.service.authentication.shiro.utils.JwtProcessors;
import org.eclipse.kapua.service.user.User;
import org.eclipse.kapua.sso.JwtProcessor;
import org.jose4j.jwt.consumer.JwtContext;

@KapuaProvider
public class RegistrationServiceImpl implements RegistrationService, AutoCloseable {

    private final JwtProcessor jwtProcessor;

    private final List<RegistrationProcessor> processors = new ArrayList<>();

    public RegistrationServiceImpl() throws IOException {
        jwtProcessor = JwtProcessors.createDefault();

        for (RegistrationProcessorProvider provider : ServiceLoader.load(RegistrationProcessorProvider.class)) {
            processors.addAll(provider.createAll());
        }
    }

    @Override
    public void close() throws Exception {
        if (jwtProcessor != null) {
            jwtProcessor.close();
        }

        // FIXME: use Suppressed

        for (final RegistrationProcessor processor : processors) {
            processor.close();
        }
    }

    @Override
    public boolean isAccountCreationEnabled() {
        return !processors.isEmpty();
    }

    @Override
    public boolean createAccount(final JwtCredentials credentials) throws KapuaException {
        if (!isAccountCreationEnabled()) {
            // early return
            return false;
        }

        try {
            final JwtContext context = jwtProcessor.process(credentials.getJwt());

            for (final RegistrationProcessor processor : processors) {
                final Optional<User> result = processor.createUser(context);
                if (result.isPresent()) {
                    return true;
                }
            }

            return false;

        } catch (final Exception e) {
            throw KapuaException.internalError(e);
        }
    }

}
