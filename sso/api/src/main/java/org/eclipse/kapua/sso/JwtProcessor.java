/*******************************************************************************
 * Copyright (c) 2019 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.sso;

import org.jose4j.jwt.consumer.JwtContext;

public interface JwtProcessor extends AutoCloseable {

    boolean validate(final String jwt) throws Exception;

    JwtContext process(final String jwt) throws Exception;
}
