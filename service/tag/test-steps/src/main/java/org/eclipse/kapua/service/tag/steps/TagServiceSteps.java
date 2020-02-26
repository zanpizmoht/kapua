/*******************************************************************************
 * Copyright (c) 2017, 2019 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech
 *******************************************************************************/
package org.eclipse.kapua.service.tag.steps;

import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.shiro.SecurityUtils;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.commons.security.KapuaSecurityUtils;
import org.eclipse.kapua.commons.security.KapuaSession;
import org.eclipse.kapua.commons.util.xml.XmlUtil;
import org.eclipse.kapua.locator.KapuaLocator;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.model.query.predicate.AttributePredicate;
import org.eclipse.kapua.qa.common.DBHelper;
import org.eclipse.kapua.qa.common.StepData;
import org.eclipse.kapua.qa.common.TestBase;
import org.eclipse.kapua.qa.common.TestJAXBContextProvider;
import org.eclipse.kapua.qa.common.cucumber.CucConfig;
import org.eclipse.kapua.service.account.Account;
import org.eclipse.kapua.service.tag.Tag;
import org.eclipse.kapua.service.tag.TagAttributes;
import org.eclipse.kapua.service.tag.TagCreator;
import org.eclipse.kapua.service.tag.TagFactory;
import org.eclipse.kapua.service.tag.TagListResult;
import org.eclipse.kapua.service.tag.TagQuery;
import org.eclipse.kapua.service.tag.TagService;
import org.junit.Assert;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Implementation of Gherkin steps used in TagService.feature scenarios.
 */
@ScenarioScoped
public class TagServiceSteps extends TestBase {

    private static final Logger logger = LoggerFactory.getLogger(TagServiceSteps.class);

    /**
     * Tag service.
     */
    private TagService tagService;
    private TagFactory tagFactory;

    private DBHelper database;

    @Inject
    public TagServiceSteps(StepData stepData, DBHelper dbHelper) {

        this.stepData = stepData;
        this.database = dbHelper;
    }

    // *************************************
    // Definition of Cucumber scenario steps
    // *************************************

    @Before
    public void beforeScenario(Scenario scenario) {

        this.scenario = scenario;
        database.setup();
        stepData.clear();

        locator = KapuaLocator.getInstance();
        tagService = locator.getService(TagService.class);
        tagFactory = locator.getFactory(TagFactory.class);

        if (isUnitTest()) {
            // Create KapuaSession using KapuaSecurtiyUtils and kapua-sys user as logged in user.
            // All operations on database are performed using system user.
            // Only for unit tests. Integration tests assume that a real logon is performed.
            KapuaSession kapuaSession = new KapuaSession(null, SYS_SCOPE_ID, SYS_USER_ID);
            KapuaSecurityUtils.setSession(kapuaSession);
        }

        // Setup JAXB context
        XmlUtil.setContextProvider(new TestJAXBContextProvider());
    }

    @After
    public void afterScenario() {

        // Clean up the database
        try {
            logger.info("Logging out in cleanup");
            if (isIntegrationTest()) {
                database.deleteAll();
                SecurityUtils.getSubject().logout();
            } else {
                database.dropAll();
                database.close();
            }
            KapuaSecurityUtils.clearSession();
        } catch (Exception e) {
            logger.error("Failed to log out in @After", e);
        }
    }

    @Given("^I configure the tag service$")
    public void setConfigurationValue(List<CucConfig> testConfigs)
            throws Exception {

        Account lastAcc = (Account) stepData.get("LastAccount");
        KapuaId scopeId = SYS_SCOPE_ID;
        KapuaId parentId = SYS_SCOPE_ID;
        if (lastAcc != null) {
            scopeId = lastAcc.getId();
            parentId = lastAcc.getScopeId();
        }
        Map<String, Object> valueMap = new HashMap<>();

        for (CucConfig config : testConfigs) {
            config.addConfigToMap(valueMap);
        }
        try {
            primeException();
            tagService.setConfigValues(scopeId, parentId, valueMap);
        } catch (KapuaException ke) {
            verifyException(ke);
        }
    }

    @Given("^I create a tag with name \"([^\"]*)\"$")
    public void tagWithName(String tagName) throws Throwable {

        TagCreator tagCreator = tagCreatorCreator(tagName);
        stepData.remove("tag");
        Tag tag = tagService.create(tagCreator);
        stepData.put("tag", tag);
    }

    @When("^Tag with name \"([^\"]*)\" is searched$")
    public void tagWithNameIfSearched(String tagName) throws Throwable {
        try {
            primeException();
            TagQuery query = tagFactory.newQuery(SYS_SCOPE_ID);
            query.setPredicate(query.attributePredicate(TagAttributes.NAME, tagName, AttributePredicate.Operator.EQUAL));
            TagListResult queryResult = tagService.query(query);
            Tag foundTag = queryResult.getFirstItem();
            stepData.put("tag", foundTag);
            stepData.put("queryResult", queryResult);
        } catch (KapuaException ke) {
            verifyException(ke);
        }

        try {
            TagQuery query = tagFactory.newQuery(SYS_SCOPE_ID);
            query.setPredicate(query.attributePredicate(TagAttributes.NAME, tagName, AttributePredicate.Operator.EQUAL));
            TagListResult queryResult = tagService.query(query);
            Tag foundTag = queryResult.getFirstItem();
            stepData.put("tag", foundTag);
            stepData.put("queryResult", queryResult);
        } catch (Exception e) {
            verifyException(e);
        }
    }

    @When("^I delete tag with name \"([^\"]*)\"$")
    public void deleteTagWithName(String tagName) throws Throwable {
        try {
            TagQuery query = tagFactory.newQuery(SYS_SCOPE_ID);
            query.setPredicate(query.attributePredicate(TagAttributes.NAME, tagName, AttributePredicate.Operator.EQUAL));
            TagListResult queryResult = tagService.query(query);
            Tag foundTag = queryResult.getFirstItem();
            tagService.delete(foundTag.getScopeId(), foundTag.getId());
        } catch (Exception e) {
            verifyException(e);
        }
    }

    @Then("^I find a tag with name \"([^\"]*)\"$")
    public void tagWithNameIsFound(String tagName) {

        Tag foundTag = (Tag) stepData.get("tag");
        Assert.assertEquals(tagName, foundTag.getName());
    }

    @Then("^No tag was found$")
    public void checkNoGroupWasFound() {

        assertNull(stepData.get("tag"));
    }

    @Then("^I find and delete tag with name \"([^\"]*)\"$")
    public void tagWithNameIsDeleted(String tagName) throws Throwable {

        try {
            Tag foundTag = (Tag) stepData.get("tag");
            TagListResult queryResult = (TagListResult) stepData.get("queryResult");
            tagService.delete(foundTag.getScopeId(), foundTag.getId());
            queryResult.clearItems();
            foundTag = queryResult.getFirstItem();
            Assert.assertEquals(null, foundTag);
        } catch (Exception e) {
            verifyException(e);
        }
    }

    /**
     * Create TagCreator for creating tag with specified name.
     *
     * @param tagName name of tag
     * @return tag creator for tag with specified name
     */
    private TagCreator tagCreatorCreator(String tagName) {

        TagCreator tagCreator = tagFactory.newCreator(SYS_SCOPE_ID);
        tagCreator.setName(tagName);

        return tagCreator;
    }

    @And("^I try to edit tag to name \"([^\"]*)\"$")
    public void tagNameIsChangedIntoName(String tagName) throws Exception {
       Tag tag = (Tag) stepData.get("tag");
       tag.setName(tagName);

       try {
           primeException();
           stepData.remove("tag");
           Tag newtag = tagService.update(tag);
           stepData.put("tag", newtag);
       } catch (KapuaException ex) {
           verifyException(ex);
       }
    }

    @And("^I delete the tag with name \"([^\"]*)\"$")
    public void tagIsDeleted(String tagName) throws Exception {
        Tag tag = (Tag) stepData.get("tag");
        assertEquals(tagName, tag.getName());

        try {
            tagService.delete(getCurrentScopeId(), tag.getId());
        } catch (KapuaException ex) {
            verifyException(ex);
        }
    }

    @And("^I create a tag with name \"([^\"]*)\" and description \"([^\"]*)\"$")
    public void iCreateATagWithNameAndDescription(String tagName, String tagDescription) throws Throwable {

        try {
            TagCreator tagCreator = tagCreatorCreatorWithDescription(tagName, tagDescription);
            stepData.remove("tag");
            Tag tag = tagService.create(tagCreator);
            stepData.put("tag", tag);
        } catch (Exception e) {
            verifyException(e);
        }
    }

    private TagCreator tagCreatorCreatorWithDescription(String tagName, String tagDescription) {

        TagCreator tagCreator = tagFactory.newCreator(SYS_SCOPE_ID);
        tagCreator.setName(tagName);
        tagCreator.setDescription(tagDescription);

        return tagCreator;
    }

    @When("^I change tag name from \"([^\"]*)\" to \"([^\"]*)\"$")
    public void iChangeTagNameFromTo(String tagName, String newTagName) throws Throwable {

        try {
            TagQuery query = tagFactory.newQuery(SYS_SCOPE_ID);
            query.setPredicate(query.attributePredicate(TagAttributes.NAME, tagName, AttributePredicate.Operator.EQUAL));
            TagListResult queryResult = tagService.query(query);
            Tag foundTag = queryResult.getFirstItem();

            foundTag.setName(newTagName);
            tagService.update(foundTag);
        } catch (Exception e) {
            verifyException(e);
        }
    }
}
