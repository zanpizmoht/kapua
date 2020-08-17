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
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.net.MalformedURLException;
import java.net.URL;

@Category(JUnitTests.class)
public class LocatorConfigTest extends Assert {

    @Test(expected = IllegalArgumentException.class)
    public void fromUrlNullTest() throws KapuaLocatorException {
        LocatorConfig.fromURL(null);
    }

    @Test(expected = KapuaLocatorException.class)
    public void fromUrlWrongConfigurationTest() throws MalformedURLException, KapuaLocatorException {
        LocatorConfig.fromURL(new URL("http://www.test.asd"));
    }

    @Test()
    public void fromUrlCorrectConfigurationTest() throws MalformedURLException, KapuaLocatorException {
        LocatorConfig config = LocatorConfig.fromURL(new URL("file:./target/test-classes/locator.xml"));
        assertNotNull(config);
        assertEquals("[org.eclipse.kapua.locator.internal.guice]", config.getPackageNames().toString());
        assertEquals("file:./target/test-classes/locator.xml", config.getURL().toString());
        assertNotNull(config.getProvidedInterfaceNames());
    }
}
