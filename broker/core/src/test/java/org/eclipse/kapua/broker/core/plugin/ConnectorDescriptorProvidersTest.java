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
package org.eclipse.kapua.broker.core.plugin;

import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class ConnectorDescriptorProvidersTest extends Assert {

    @Test
    public void getInstanceProviderTest() {
        try {
            ConnectorDescriptorProvider provider = ConnectorDescriptorProviders.getInstance();
            assertTrue(provider.toString().startsWith("org.eclipse.kapua.broker.core.plugin.DefaultConnectorDescriptionProvider"));
        } catch (Exception e) {
            fail("No exception should be thrown");
        }
    }

    @Test
    public void getDescriptorNullTest() {
        ConnectorDescriptor descriptor = ConnectorDescriptorProviders.getDescriptor(null);
        assertTrue(descriptor.toString().startsWith("org.eclipse.kapua.broker.core.plugin.ConnectorDescriptor"));

    }

    @Test
    public void getDescriptorMultipleValuesTest() {
        String[] values = {"1", "", "123123", "asdaf", "asdsad2123", "a", "#$$#žčš"};
        for (String value : values) {
            ConnectorDescriptor descriptor = ConnectorDescriptorProviders.getDescriptor(value);
            assertTrue(descriptor.toString().startsWith("org.eclipse.kapua.broker.core.plugin.ConnectorDescriptor"));
        }
    }

}
