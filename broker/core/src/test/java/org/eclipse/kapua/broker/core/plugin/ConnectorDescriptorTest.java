/*******************************************************************************
 * Copyright (c) 2017, 2020 Red Hat Inc and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Red Hat Inc - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.broker.core.plugin;

import org.apache.commons.lang3.StringUtils;
import org.eclipse.kapua.KapuaErrorCodes;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.broker.core.KapuaBrokerJAXBContextLoader;
import org.eclipse.kapua.broker.core.plugin.ConnectorDescriptor.MessageType;
import org.eclipse.kapua.broker.core.setting.BrokerSetting;
import org.eclipse.kapua.broker.core.setting.BrokerSettingKey;
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.util.HashMap;
import java.util.Map;

@Category(JUnitTests.class)
public class ConnectorDescriptorTest extends Assert {

    private static final String BROKER_IP_RESOLVER_CLASS_NAME;

    private KapuaBrokerJAXBContextLoader kapuaBrokerJAXBContextLoader;

    static {
        BrokerSetting config = BrokerSetting.getInstance();
        BROKER_IP_RESOLVER_CLASS_NAME = config.getString(BrokerSettingKey.BROKER_IP_RESOLVER_CLASS_NAME);
    }

    @Before
    public void resetSettings() throws KapuaException {
        kapuaBrokerJAXBContextLoader = new KapuaBrokerJAXBContextLoader();
        kapuaBrokerJAXBContextLoader.init();
        BrokerSetting.resetInstance();
    }

    @After
    public void resetJAXBContext() {
        kapuaBrokerJAXBContextLoader.reset();
    }

    /**
     * A simple test to get a default descriptor
     */
    @Test
    public void nonNullProviderTest() {
        ConnectorDescriptorProvider provider = ConnectorDescriptorProviders.getInstance();
        assertNotNull(provider);
    }

    /**
     * A simple test to get a descriptor
     */
    @Test
    public void defaultDescriptorFromProviderTest() {
        ConnectorDescriptorProvider provider = ConnectorDescriptorProviders.getInstance();
        ConnectorDescriptor descriptor = provider.getDescriptor("foo");
        assertNotNull(descriptor);
    }

    /**
     * A simple test to get a descriptor
     */
    @Test
    public void getDescriptorFromProvidersClassTest() {
        assertNotNull(ConnectorDescriptorProviders.getDescriptor("foo"));
    }

    /**
     * Test for getTransportProtocol
     */
    @Test
    public void getTransportProtocolTest() {
        ConnectorDescriptorProvider provider = ConnectorDescriptorProviders.getInstance();
        ConnectorDescriptor descriptor = provider.getDescriptor("foo");
        assertEquals("MQTT", descriptor.getTransportProtocol());
    }

    /**
     * Use a default provider, disabling the default descriptor
     * <p>
     * The result has to be a {@code null} descriptor
     * </p>
     */
    @Test
    public void defaultProviderWithDisabledDefaultDescriptorTest() {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.DISABLE_DEFAULT_CONNECTOR_DESCRIPTOR.key(), "true");

        Tests.runWithProperties(properties, () -> {
            DefaultConnectorDescriptionProvider provider = new DefaultConnectorDescriptionProvider();
            ConnectorDescriptor descriptor = provider.getDescriptor("foo");
            Assert.assertNull(descriptor);
        });
    }

    /**
     * Use a default provider, configuring a file which does not exist
     */
    @Test(expected = Exception.class)
    public void defaultProviderWithNonExistingFileTest() {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.CONFIGURATION_URI.key(), "file:src/test/resources/does-not-exist.properties");

        Tests.runWithProperties(properties, DefaultConnectorDescriptionProvider::new);
    }

    /**
     * Use a default provider, configuring a file which does exist, but allow default fallback
     */
    @Test
    public void defaultProviderAllowingDefaultFallbackTest() {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.CONFIGURATION_URI.key(), "file:src/test/resources/conector.descriptor/1.properties");

        Tests.runWithProperties(properties, () -> {
            DefaultConnectorDescriptionProvider provider = new DefaultConnectorDescriptionProvider();
            ConnectorDescriptor descriptor = provider.getDescriptor("foo");
            Assert.assertNotNull(descriptor);
        });
    }

    /**
     * Use a default provider, configuring an empty file, disabling default
     */
    @Test
    public void defaultProviderWithEmptyFileTest() {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.DISABLE_DEFAULT_CONNECTOR_DESCRIPTOR.key(), "true");
        properties.put(BrokerSettingKey.CONFIGURATION_URI.key(), "file:src/test/resources/conector.descriptor/1.properties");

        Tests.runWithProperties(properties, () -> {
            DefaultConnectorDescriptionProvider provider = new DefaultConnectorDescriptionProvider();
            ConnectorDescriptor descriptor = provider.getDescriptor("foo");
            Assert.assertNull(descriptor);
        });
    }

    /**
     * Use a default provider, configuring a non-empty configuration
     */
    @Test
    public void defaultProviderUsingNonEmptyConfigurationTest() throws Exception {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.DISABLE_DEFAULT_CONNECTOR_DESCRIPTOR.key(), "true");
        properties.put(BrokerSettingKey.CONFIGURATION_URI.key(), "file:src/test/resources/conector.descriptor/2.properties");

        Tests.runWithProperties(properties, () -> {
            DefaultConnectorDescriptionProvider provider = new DefaultConnectorDescriptionProvider();
            Assert.assertNull(provider.getDescriptor("foo"));

            ConnectorDescriptor descriptor = provider.getDescriptor("mqtt");
            Assert.assertNotNull(descriptor);

            Assert.assertEquals(org.eclipse.kapua.service.device.call.message.kura.lifecycle.KuraAppsMessage.class, descriptor.getDeviceClass(MessageType.APP));
            Assert.assertEquals(org.eclipse.kapua.message.device.lifecycle.KapuaAppsMessage.class, descriptor.getKapuaClass(MessageType.APP));

            Assert.assertNull(descriptor.getDeviceClass(MessageType.DATA));
            Assert.assertNull(descriptor.getKapuaClass(MessageType.DATA));
        });
    }

    /**
     * Use a default provider, configuring a non-empty, invalid configuration
     */
    @Test(expected = Exception.class)
    public void defaultProviderWithInvalidConfigurationTest() {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.DISABLE_DEFAULT_CONNECTOR_DESCRIPTOR.key(), "true");
        properties.put(BrokerSettingKey.CONFIGURATION_URI.key(), "file:src/test/resources/conector.descriptor/3.properties");

        Tests.runWithProperties(properties, DefaultConnectorDescriptionProvider::new);
    }

    /**
     * Empty configuration URL
     */
    @Test
    public void emptyConfigurationUrlTest() {
        final Map<String, String> properties = new HashMap<>();
        properties.put(BrokerSettingKey.CONFIGURATION_URI.key(), "");

        Tests.runWithProperties(properties, DefaultConnectorDescriptionProvider::new);
    }

    @Test
    public void testBrokerIpOrHostNameConfigFile() throws Exception {
        System.clearProperty("broker.ip");
        System.setProperty("kapua.config.url", "broker.setting/kapua-broker-setting-1.properties");

        BrokerIpResolver brokerIpResolver = newInstance(BROKER_IP_RESOLVER_CLASS_NAME, DefaultBrokerIpResolver.class);
        String ipOrHostName = brokerIpResolver.getBrokerIpOrHostName();
        Assert.assertEquals("192.168.33.10", ipOrHostName);
    }

    @Test
    public void testBrokerIpOrHostNameEnvProperty() throws Exception {
        System.clearProperty("kapua.config.url");
        System.setProperty("broker.ip", "192.168.33.10");

        BrokerIpResolver brokerIpResolver = newInstance(BROKER_IP_RESOLVER_CLASS_NAME, DefaultBrokerIpResolver.class);
        String ipOrHostName = brokerIpResolver.getBrokerIpOrHostName();
        Assert.assertEquals("192.168.33.10", ipOrHostName);
    }

    @Test
    public void testBrokerIpOrHostNameEmptyConfigFile() throws Exception {
        System.clearProperty("broker.ip");
        System.setProperty("kapua.config.url", "broker.setting/kapua-broker-setting-2.properties");

        BrokerIpResolver brokerIpResolver = newInstance(BROKER_IP_RESOLVER_CLASS_NAME, DefaultBrokerIpResolver.class);
        String ipOrHostName = brokerIpResolver.getBrokerIpOrHostName();
        Assert.assertEquals("192.168.33.10", ipOrHostName);
    }

    @Test(expected = Exception.class)
    public void testBrokerIpOrHostNameNoEnvProperty() throws Exception {
        System.clearProperty("broker.ip");
        System.setProperty("kapua.config.url", "broker.setting/kapua-broker-setting-3.properties");

        BrokerIpResolver brokerIpResolver = newInstance(BROKER_IP_RESOLVER_CLASS_NAME, DefaultBrokerIpResolver.class);
        brokerIpResolver.getBrokerIpOrHostName();
    }

    /**
     * Code reused form KapuaSecurityBrokerFilter for instantiating broker ip resolver class.
     *
     * @param clazz           class that instantiates broker ip resolver
     * @param defaultInstance default instance of class
     * @param <T>             generic type
     * @return instance of ip resolver
     * @throws KapuaException
     */
    protected <T> T newInstance(String clazz, Class<T> defaultInstance) throws KapuaException {
        T instance;
        // lazy synchronization
        try {
            if (!StringUtils.isEmpty(clazz)) {
                Class<T> clazzToInstantiate = (Class<T>) Class.forName(clazz);
                instance = clazzToInstantiate.newInstance();
            } else {
                instance = defaultInstance.newInstance();
            }
        } catch (InstantiationException | IllegalAccessException | ClassNotFoundException e) {
            throw new KapuaException(KapuaErrorCodes.INTERNAL_ERROR, e, "Class instantiation exception " + clazz);
        }

        return instance;
    }

}
