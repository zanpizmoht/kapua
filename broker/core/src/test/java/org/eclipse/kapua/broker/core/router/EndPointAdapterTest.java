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

import com.sun.org.apache.xerces.internal.dom.CoreDocumentImpl;
import com.sun.org.apache.xerces.internal.dom.ElementImpl;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.eclipse.persistence.jaxb.JAXBMarshaller;
import org.eclipse.persistence.jaxb.JAXBUnmarshaller;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.util.List;

@Category(JUnitTests.class)
public class EndPointAdapterTest extends Assert {

    EndPointAdapter endPointAdapter;

    @Before
    public void start() {
        endPointAdapter = new EndPointAdapter();
    }

    @Test
    public void unmarshalTest() throws Exception {
        ElementImpl element = new ElementImpl(new CoreDocumentImpl(), "name1");
        List<EndPoint> l = endPointAdapter.unmarshal(element);
        assertNotNull(l);
        assertEquals(0, l.size());
    }

    @Test(expected = ClassCastException.class)
    public void marshalTest() throws Exception {
        ElementImpl element = new ElementImpl(new CoreDocumentImpl(), "name1");
        List<EndPoint> l = endPointAdapter.unmarshal(element);
        endPointAdapter.marshal(l);
    }

    @Test
    public void jaxbContextHandlerTest() {
        Marshaller marshaller = JaxbContextHandler.getMarshaller();
        Unmarshaller unmarshaller = JaxbContextHandler.getUnmarshaller();
        assertNotNull(marshaller);
        assertNotNull(unmarshaller);
        assertEquals(JAXBMarshaller.class, marshaller.getClass());
        assertEquals(JAXBUnmarshaller.class, unmarshaller.getClass());
    }

}
