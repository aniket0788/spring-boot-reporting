package com.nationstar.reportengine;

import java.util.Map;

import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import com.google.gson.Gson;
import com.nationstar.reportengine.util.TestUtil;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
public class ReportsEngineApplicationTests {

	private static final String HOST_URL = "http://localhost:8090/";

	@Autowired
	private MockMvc mockMVC;

	// @Test
	public void contextLoads() {
	}

	private MockHttpServletRequestBuilder buildRequestWithParam(Map<String, String> requestparam, String contextpath) {
		MockHttpServletRequestBuilder requestBuilders = MockMvcRequestBuilders
				.post(HOST_URL.concat((String) requestparam.get(contextpath)));
		requestBuilders.contentType(MediaType.APPLICATION_JSON_VALUE);
		Gson gson = new Gson();
		String json = gson.toJson(requestparam);
		requestBuilders.content(json);
		return requestBuilders;
	}

	@Test
	public void testCPIMECA1() throws Exception {

		Map<String, String> requestparam = TestUtil.getInputRequest("CPI_MECA1");
		ResultActions resultActions = this.mockMVC.perform(buildRequestWithParam(requestparam, "contextpath"));
		MvcResult mvcResult = resultActions.andReturn();
		Assert.assertEquals(200, mvcResult.getResponse().getStatus());
		/*StringBuilder builder=new StringBuilder();
				builder.append("{").append(mvcResult.getResponse().getContentAsString()).append("}");
		JSONObject resultJSON = new JSONObject(builder.toString());
		Assert.assertNotNull(resultJSON);
		Assert.assertTrue(resultJSON.length()>0);*/

	}

	@Test
	public void testCPIDETAILS() throws Exception {

		Map<String, String> requestparam = TestUtil.getInputRequest("CPI_DETAILS");
		ResultActions resultActions = this.mockMVC.perform(buildRequestWithParam(requestparam, "contextpath"));
		MvcResult mvcResult = resultActions.andReturn();
		Assert.assertEquals(200, mvcResult.getResponse().getStatus());
		/*StringBuilder builder=new StringBuilder();
		builder.append("{").append(mvcResult.getResponse().getContentAsString()).append("}");
		JSONObject resultJSON = new JSONObject(builder.toString());
		//Assert.assertTrue(resultJSON.getString("responseMessage").contains("Report Processing completed Successfully"));
		//Assert.assertEquals("200", resultJSON.getString("reponseCode"));
		Assert.assertNotNull(resultJSON);
		Assert.assertTrue(resultJSON.length()>0);*/

	}
	@Test
	public void testPrivateInvestorDETAILS() throws Exception {

		Map<String, String> requestparam = TestUtil.getInputRequest("Private_investor_Details");
		ResultActions resultActions = this.mockMVC.perform(buildRequestWithParam(requestparam, "contextpath"));
		MvcResult mvcResult = resultActions.andReturn();
		Assert.assertEquals(200, mvcResult.getResponse().getStatus());
		/*StringBuilder builder=new StringBuilder();
		builder.append("{").append(mvcResult.getResponse().getContentAsString()).append("}");
		JSONObject resultJSON = new JSONObject(builder.toString());
		//Assert.assertTrue(resultJSON.getString("responseMessage").contains("Report Processing completed Successfully"));
		//Assert.assertEquals("200", resultJSON.getString("reponseCode"));
		Assert.assertNotNull(resultJSON);
		Assert.assertTrue(resultJSON.length()>0);*/

	}
}
