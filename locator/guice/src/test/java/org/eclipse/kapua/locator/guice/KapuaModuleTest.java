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
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class KapuaModuleTest extends Assert {

    KapuaModule kapuaModule;

    @Before
    public void start() {
        kapuaModule = new KapuaModule();
    }

    @Test
    public void secondConstructorConfigureTest() {
        String[] resourceNames = {"a", "123", "0", "asdsadg2313", "$$$%#$&@}§{", ""};

        for (String resourceName : resourceNames) {
            try {
                KapuaModule module = new KapuaModule(resourceName);
                module.configure();
                fail("Exception should be thrown.");
            } catch (KapuaRuntimeException e) {
                // pass
            }
        }
    }

    @Test
    public void configureTest() {
        try {
            kapuaModule.configure();
            fail("Exception should be thrown");
        } catch (KapuaRuntimeException e) {
            // pass
        }
    }
}
