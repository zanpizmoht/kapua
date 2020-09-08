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
public class JmsAssistantProducerWrapperFactoryTest extends Assert {

    @Test
    public void constructorTest() {
        String[] destinations = {"a", "test1", "D123", "123", "-123", "asdas@$#", null};
        for (String destination : destinations) {
            try {
                JmsAssistantProducerWrapperFactory wrapperFactory = new JmsAssistantProducerWrapperFactory(destination);
            } catch (Exception e) {
                fail("No exception should be thrown");
            }
        }
    }

}
