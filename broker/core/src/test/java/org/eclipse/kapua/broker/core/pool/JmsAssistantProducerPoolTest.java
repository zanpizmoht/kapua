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

import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class JmsAssistantProducerPoolTest extends Assert {

    @Test
    public void constructorTest() {
        String[] destinations = {"test", "destination1234", "asd#$$%%/(@", "123", "-23", null};
        for (String destination : destinations) {
            try {
                JmsAssistantProducerPool pool = new JmsAssistantProducerPool(new JmsAssistantProducerWrapperFactory(destination));
            } catch (Exception e) {
                fail("No exception should be thrown");
            }
        }
    }

    @Test
    public void getIOnstanceTest() {
        JmsAssistantProducerPool pool = JmsAssistantProducerPool.getIOnstance(JmsAssistantProducerPool.DESTINATIONS.NO_DESTINATION);
        assertEquals("Unexpected value", "org.eclipse.kapua.broker.core.pool.JmsAssistantProducerWrapperFactory<org.eclipse.kapua.broker.core.pool.JmsAssistantProducerWrapper>", pool.getFactoryType());
    }

    @Test
    public void getIOnstanceNullTest() {
        JmsAssistantProducerPool pool = JmsAssistantProducerPool.getIOnstance(null);
        assertNull(pool);
    }

    @Test
    public void closePools() {
        try {
            JmsAssistantProducerPool.closePools();
        } catch (Exception e) {
            fail("Exception should not be thrown");
        }
    }

}
