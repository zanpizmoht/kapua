/*******************************************************************************
 * Copyright (c) 2017, 2020 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.job.step.definition;

public interface JobStepProperty {

    String getName();

    void setName(String name);

    String getPropertyType();

    void setPropertyType(String propertyType);

    String getPropertyValue();

    void setPropertyValue(String propertyValue);

    String getExampleValue();

    void setExampleValue(String exampleValue);

}
