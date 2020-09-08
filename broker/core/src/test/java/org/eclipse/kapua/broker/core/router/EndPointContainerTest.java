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
package org.eclipse.kapua.broker.core.router;

import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.util.ArrayList;
import java.util.List;


@Category(JUnitTests.class)
public class EndPointContainerTest extends Assert {

    @Test
    public void getSetEndPointsTest() {
        EndPointContainer container = new EndPointContainer();
        assertEquals(0, container.getEndPoints().size());
        List<EndPoint> endPoints = new ArrayList<>();
        EndPoint endPoint = new EndChainEndPoint();
        endPoints.add(endPoint);
        container.setEndPoints(endPoints);
        assertEquals(1, container.getEndPoints().size());
        assertEquals(endPoint, container.getEndPoints().get(0));
    }

}
