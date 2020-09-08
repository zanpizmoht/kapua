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
package org.eclipse.kapua.broker.core.setting;

import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(JUnitTests.class)
public class BrokerSettingKeyTest extends Assert {

    @Test
    public void keysTest() {
        assertEquals("broker.connector.descriptor.default.disable", BrokerSettingKey.DISABLE_DEFAULT_CONNECTOR_DESCRIPTOR.key());
        assertEquals("broker.connector.descriptor.configuration.uri", BrokerSettingKey.CONFIGURATION_URI.key());
        assertEquals("broker.jaxb_context_class_name", BrokerSettingKey.BROKER_JAXB_CONTEXT_CLASS_NAME.key());
        assertEquals("broker.ip_resolver_class_name", BrokerSettingKey.BROKER_IP_RESOLVER_CLASS_NAME.key());
        assertEquals("broker.id_resolver_class_name", BrokerSettingKey.BROKER_ID_RESOLVER_CLASS_NAME.key());
        assertEquals("broker.ip", BrokerSettingKey.BROKER_IP.key());
        assertEquals("broker.system.message_creator_class_name", BrokerSettingKey.SYSTEM_MESSAGE_CREATOR_CLASS_NAME.key());
        assertEquals("broker.authenticator_class_name", BrokerSettingKey.AUTHENTICATOR_CLASS_NAME.key());
        assertEquals("broker.stealing_link.enabled", BrokerSettingKey.BROKER_STEALING_LINK_ENABLED.key());
        assertEquals("broker.stealing_link.initialization_max_wait_time", BrokerSettingKey.STEALING_LINK_INITIALIZATION_MAX_WAIT_TIME.key());
        assertEquals("broker.client_pool.no_dest_total_max_size", BrokerSettingKey.BROKER_CLIENT_POOL_NO_DEST_TOTAL_MAX_SIZE.key());
        assertEquals("broker.client_pool.no_dest_max_size", BrokerSettingKey.BROKER_CLIENT_POOL_NO_DEST_MAX_SIZE.key());
        assertEquals("broker.client_pool.no_dest_min_size", BrokerSettingKey.BROKER_CLIENT_POOL_NO_DEST_MIN_SIZE.key());
        assertEquals("broker.name", BrokerSettingKey.BROKER_NAME.key());
        assertEquals("camel.default_route.configuration_file_name", BrokerSettingKey.CAMEL_DEFAULT_ROUTE_CONFIGURATION_FILE_NAME.key());
    }

}
