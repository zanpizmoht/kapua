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

import org.eclipse.kapua.locator.KapuaLocatorException;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class FactoryResolverTest extends Assert {

    FactoryResolver factoryResolver;

    @Before
    public void start() throws KapuaLocatorException {
        factoryResolver = FactoryResolver.newInstance(Object.class, String.class);
    }

    @Test(expected = NullPointerException.class)
    public void newInstanceWithNullTest() throws KapuaLocatorException {
        FactoryResolver.newInstance(null, null);
    }

    @Test(expected = KapuaLocatorException.class)
    public void newInstanceNonAssignableClassesTest() throws KapuaLocatorException {
        FactoryResolver.newInstance(Integer.class, String.class);
    }

    @Test(expected = KapuaLocatorException.class)
    public void newInstanceAssignableClassesTest() throws KapuaLocatorException {
        FactoryResolver.newInstance(Integer.class, String.class);
    }

    @Test
    public void getFactoryClassTest() {
        assertEquals(Object.class, factoryResolver.getFactoryClass());
    }

    @Test
    public void getImplementationClassTest() {
        assertEquals(String.class, factoryResolver.getImplementationClass());
    }
}
