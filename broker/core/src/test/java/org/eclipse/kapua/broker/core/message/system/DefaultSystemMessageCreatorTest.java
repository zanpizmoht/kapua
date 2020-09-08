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
package org.eclipse.kapua.broker.core.message.system;

import org.eclipse.kapua.broker.core.plugin.KapuaConnectionContext;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.util.Map;

@Category(JUnitTests.class)
public class DefaultSystemMessageCreatorTest extends Assert {

    @Test
    public void constructorTest() {
        try {
            DefaultSystemMessageCreator messageCreator = new DefaultSystemMessageCreator();
        } catch (Exception e) {
            fail("No exception should be thrown");
        }
    }

    @Test(expected = NullPointerException.class)
    public void createMessageNullTest() {
        DefaultSystemMessageCreator messageCreator = new DefaultSystemMessageCreator();
        String result = messageCreator.createMessage(null, null);
    }

    @Test(expected = NullPointerException.class)
    public void createMessageNullMessageTypeTest() {
        DefaultSystemMessageCreator messageCreator = new DefaultSystemMessageCreator();
        KapuaConnectionContext kcc = new KapuaConnectionContext(new Long("1"), "1", "client1");
        String result = messageCreator.createMessage(null, kcc);
    }

    @Test(expected = NullPointerException.class)
    public void createMessageNullKbcTest() {
        DefaultSystemMessageCreator messageCreator = new DefaultSystemMessageCreator();
        String result = messageCreator.createMessage(SystemMessageCreator.SystemMessageType.CONNECT, null);
    }

    @Test
    public void createMessageTest() {
        DefaultSystemMessageCreator messageCreator = new DefaultSystemMessageCreator();
        KapuaConnectionContext kcc = new KapuaConnectionContext(new Long("1"), "1", "client1");
        String result = messageCreator.createMessage(SystemMessageCreator.SystemMessageType.CONNECT, kcc);
        assertNotNull(result);
        assertEquals("Event,CONNECT,,DeviceId,1,,Username,null", result);
    }

    @Test
    public void convertFromTest() {
        DefaultSystemMessageCreator messageCreator = new DefaultSystemMessageCreator();
        Map<String, String> map = messageCreator.convertFrom("DeviceId,device1,,Username,user1");
        assertEquals("device1", messageCreator.getDeviceId(map));
        assertEquals("user1", messageCreator.getUsername(map));
    }

}
