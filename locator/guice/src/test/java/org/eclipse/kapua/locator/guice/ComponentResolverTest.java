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

import org.eclipse.kapua.commons.util.StringUtil;
import org.eclipse.kapua.locator.KapuaLocatorException;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class ComponentResolverTest extends Assert {

    ComponentResolver componentResolver;

    @Before
    public void start() throws KapuaLocatorException {
        componentResolver = ComponentResolver.newInstance(Object.class, String.class);
    }

    @Test(expected = NullPointerException.class)
    public void newInstanceWithNullTest() throws KapuaLocatorException {
        ComponentResolver.newInstance(null, null);
    }

    @Test(expected = KapuaLocatorException.class)
    public void newInstanceNonAssignableClassesTest() throws KapuaLocatorException {
        ComponentResolver.newInstance(Integer.class, String.class);
    }

    @Test
    public void newInstanceAssignableClassesTest() throws KapuaLocatorException {
        ComponentResolver.newInstance(Object.class, StringUtil.class);
    }

    @Test
    public void getProvidedClassTest() {
        assertEquals(Object.class, componentResolver.getProvidedClass());
    }

    @Test
    public void getImplementationClassTest() {
        assertEquals(String.class, componentResolver.getImplementationClass());
    }
}
