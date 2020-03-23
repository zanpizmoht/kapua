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
package org.eclipse.kapua.sso.provider.keycloak;

import org.eclipse.kapua.sso.JwtProcessor;
import org.eclipse.kapua.sso.SingleSignOnService;
import org.eclipse.kapua.sso.provider.SingleSignOnProvider.ProviderLocator;
import org.eclipse.kapua.sso.provider.keycloak.jwt.KeycloakJwtProcessor;

import java.io.IOException;

public class KeycloakSingleSignOnLocator implements ProviderLocator {

    @Override
    public SingleSignOnService getService() {
        return new KeycloakSingleSignOnService();
    }

    @Override
    public JwtProcessor getProcessor() throws IOException {
        return new KeycloakJwtProcessor();
    }

    @Override
    public void close() throws Exception {
    }

}
