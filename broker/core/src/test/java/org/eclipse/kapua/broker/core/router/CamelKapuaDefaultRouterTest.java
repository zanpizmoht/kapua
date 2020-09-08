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

import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.broker.core.KapuaBrokerJAXBContextLoader;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class CamelKapuaDefaultRouterTest extends Assert {

    CamelKapuaDefaultRouter defaultRouter;
    private KapuaBrokerJAXBContextLoader kapuaBrokerJAXBContextLoader;

    @Before
    public void start() throws KapuaException {
        kapuaBrokerJAXBContextLoader = new KapuaBrokerJAXBContextLoader();
        kapuaBrokerJAXBContextLoader.init();
        defaultRouter = new CamelKapuaDefaultRouter();
    }

    @After
    public void resetJAXBContext() {
        kapuaBrokerJAXBContextLoader.reset();
    }

    @Test(expected = NullPointerException.class)
    public void defaultRouteNullTest() {
        defaultRouter.defaultRoute(null, null, null, null);
    }

}
