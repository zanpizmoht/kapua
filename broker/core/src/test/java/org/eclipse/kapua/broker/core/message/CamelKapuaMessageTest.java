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
package org.eclipse.kapua.broker.core.message;

import org.eclipse.kapua.broker.core.plugin.ConnectorDescriptor;
import org.eclipse.kapua.broker.core.plugin.ConnectorDescriptorProvider;
import org.eclipse.kapua.broker.core.plugin.ConnectorDescriptorProviders;
import org.eclipse.kapua.message.KapuaMessage;
import org.eclipse.kapua.message.KapuaMessageFactory;
import org.eclipse.kapua.message.internal.KapuaMessageFactoryImpl;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class CamelKapuaMessageTest extends Assert {

    CamelKapuaMessage message;

    @Before
    public void start() {
        message = new CamelKapuaMessage(null, null, null);
    }

    @Test
    public void setAndGetMessageTest() {
        KapuaMessageFactory messageFactory = new KapuaMessageFactoryImpl();
        KapuaMessage m = messageFactory.newMessage();
        message.setMessage(m);
        assertEquals(m, message.getMessage());
    }

    @Test
    public void setAndGetConnectionIdTest() {
        KapuaId id = KapuaId.ONE;
        message.setConnectionId(id);
        assertEquals(id, message.getConnectionId());
    }

    @Test
    public void setAndGetDatastoreIdTest() {
        String[] ids = {"1", "awsd", "123123123", "-123", "ASDa12$%~"};
        for (String id : ids) {
            message.setDatastoreId(id);
            assertEquals(id, message.getDatastoreId());
        }
    }

    @Test
    public void setAndGetConnectorDescriptorTest() {
        ConnectorDescriptorProvider descriptorProvider = ConnectorDescriptorProviders.getInstance();
        ConnectorDescriptor descriptor = descriptorProvider.getDescriptor("test");
        message.setConnectorDescriptor(descriptor);
        assertEquals(descriptor, message.getConnectorDescriptor());
    }

}
