/*******************************************************************************
 * Copyright (c) 2017, 2020 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.locator.guice;

import org.eclipse.kapua.locator.KapuaLocatorException;
import org.eclipse.kapua.locator.internal.guice.FactoryA;
import org.eclipse.kapua.locator.internal.guice.FactoryAImpl;
import org.eclipse.kapua.locator.internal.guice.ServiceA;
import org.eclipse.kapua.locator.internal.guice.ServiceC;
import org.eclipse.kapua.locator.internal.guice.ServiceCImpl;
import org.eclipse.kapua.locator.internal.guice.ServiceAImpl;
import org.eclipse.kapua.locator.internal.guice.FactoryC;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;


@Category(JUnitTests.class)
public class ServiceResolverTest extends Assert {

    @Test(expected = KapuaLocatorException.class)
    public void wrongServiceClasTest() throws KapuaLocatorException {
        ServiceResolver resolver = ServiceResolver.newInstance(ServiceC.class, ServiceCImpl.class);
    }

    @Test
    public void correctServiceClassTest() throws KapuaLocatorException {
        ServiceResolver resolver = ServiceResolver.newInstance(ServiceA.class, ServiceAImpl.class);
        assertEquals(ServiceAImpl.class, resolver.getImplementationClass());
        assertEquals(ServiceA.class, resolver.getServiceClass());
    }

    @Test(expected = KapuaLocatorException.class)
    public void wrongFactoryClassTest() throws KapuaLocatorException {
        ServiceResolver resolver = ServiceResolver.newInstance(FactoryC.class, ServiceCImpl.class);
    }

    @Test
    public void correctFactoryClassTest() throws KapuaLocatorException {
        ServiceResolver resolver = ServiceResolver.newInstance(FactoryA.class, FactoryAImpl.class);
        assertEquals(FactoryAImpl.class, resolver.getImplementationClass());
        assertEquals(FactoryA.class, resolver.getServiceClass());
    }
}