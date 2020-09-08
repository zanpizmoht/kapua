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
package org.eclipse.kapua.broker.core.pool;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class JmsConnectionFactoryTest extends Assert {

    @Test
    public void staticVarTest() {
        ActiveMQConnectionFactory connectionFactory = JmsConnectionFactory.VM_CONN_FACTORY;
        assertTrue(connectionFactory.isOptimizedMessageDispatch());
        assertTrue(connectionFactory.isUseAsyncSend());
        assertFalse(connectionFactory.isOptimizeAcknowledge());
        assertFalse(connectionFactory.isDispatchAsync());
        assertFalse(connectionFactory.isCopyMessageOnSend());
        assertFalse(connectionFactory.isAlwaysSyncSend());
        assertFalse(connectionFactory.isAlwaysSessionAsync());
    }

}
