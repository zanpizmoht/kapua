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

import org.eclipse.kapua.locator.internal.guice.FactoryA;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class SyntheticMethodMatcherTest extends Assert {

    @Test
    public void getInstanceTest() {
        SyntheticMethodMatcher matcher = SyntheticMethodMatcher.getInstance();
        assertNotNull(matcher);
    }

    @Test
    public void matchesTest() throws NoSuchMethodException {
        SyntheticMethodMatcher matcher = SyntheticMethodMatcher.getInstance();
        assertFalse(matcher.matches(FactoryA.class.getMethod("newKapuaId", String.class)));
        assertFalse(matcher.matches(String.class.getMethod("startsWith", String.class)));
    }
}