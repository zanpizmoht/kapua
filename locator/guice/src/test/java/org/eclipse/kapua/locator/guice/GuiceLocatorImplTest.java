/*******************************************************************************
 * Copyright (c) 2020 Eurotech and/or its affiliates and others
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

import org.eclipse.kapua.KapuaRuntimeException;
import org.eclipse.kapua.locator.internal.guice.FactoryA;
import org.eclipse.kapua.locator.internal.guice.FactoryC;
import org.eclipse.kapua.locator.internal.guice.ServiceA;
import org.eclipse.kapua.locator.internal.guice.ServiceAImpl;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.eclipse.kapua.service.KapuaService;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.util.List;

@Category(JUnitTests.class)
public class GuiceLocatorImplTest extends Assert {

    GuiceLocatorImpl guiceLocator;

    @Before
    public void start() {
        guiceLocator = new GuiceLocatorImpl();
    }

    @Test
    public void secondConstructorRandomStringTest() {
        String[] resourceNames = {"1.xml", "012301230123.xml", "asdadgd", "a", "@{^˘!%%&", "asd2313@", "žšč", null};

        for (String resourceName : resourceNames) {
            try {
                GuiceLocatorImpl locator = new GuiceLocatorImpl(resourceName);
                fail("Exception should be thrown");
            } catch (Exception e) {
                // OK
            }
        }
    }

    @Test
    public void secondConstructorLocatorTest() {
        try {
            GuiceLocatorImpl locator = new GuiceLocatorImpl("locator.xml");
        } catch (Exception e) {
            fail("No exception should be thrown");
        }
    }

    @Test
    public void getServiceAvailableTest() {
        Object service = guiceLocator.getService(ServiceA.class);
        assertTrue(service instanceof ServiceA);
    }

    @Test(expected = KapuaRuntimeException.class)
    public void getServiceNotAvailableTest() {
        Object service = guiceLocator.getService(KapuaService.class);
    }

    @Test(expected = NullPointerException.class)
    public void getServiceNullTest() {
        Object service = guiceLocator.getService(null);
    }

    @Test
    public void getFactoryAvailableTest() {
        Object service = guiceLocator.getFactory(FactoryA.class);
        assertTrue(service instanceof FactoryA);
    }

    @Test(expected = KapuaRuntimeException.class)
    public void getFactoryNotAvailableTest() {
        Object service = guiceLocator.getFactory(FactoryC.class);
    }

    @Test(expected = NullPointerException.class)
    public void getFactoryNullTest() {
        Object service = guiceLocator.getFactory(null);
    }

    @Test
    public void getComponentAvailableTest() {
        Object service = guiceLocator.getComponent(FactoryA.class);
        assertTrue(service instanceof FactoryA);
    }

    @Test(expected = KapuaRuntimeException.class)
    public void getComponentNotAvailableTest() {
        Object service = guiceLocator.getComponent(FactoryC.class);
    }

    @Test(expected = NullPointerException.class)
    public void getComponentNullTest() {
        Object service = guiceLocator.getComponent(null);
    }

    @Test
    public void getServicesTest() {
        List<KapuaService> list = guiceLocator.getServices();
        assertNotNull(list);
        assertEquals(1, list.size());
        assertTrue(list.get(0) instanceof ServiceAImpl);
    }
}
