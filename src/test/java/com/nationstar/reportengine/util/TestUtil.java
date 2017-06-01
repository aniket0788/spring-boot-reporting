package com.nationstar.reportengine.util;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Scanner;

import org.json.JSONArray;
import org.json.JSONObject;

public class TestUtil {

	@SuppressWarnings({ "rawtypes" })
	public static final Map<String, String> getInputRequest(String module) {
		InputStream inputStream = ClassLoader
				.getSystemResourceAsStream("testrequest.json");
		Scanner scanner = new Scanner(inputStream);
		scanner.useDelimiter("\\A");
		String sqlString = scanner.hasNext() ? scanner.next() : "";
		System.out.println(sqlString);
		scanner.close();
		JSONObject jsonObject = new JSONObject(sqlString);
		JSONArray jsonArray = jsonObject.getJSONArray(module);
		JSONObject json = jsonArray.getJSONObject(0);
		Iterator itr = json.keys();
		Map<String, String> map = new HashMap<String, String>();
		String key = null;
		while (itr.hasNext()) {
			key = (String) itr.next();
			map.put(key, (String) json.get(key));
		}
		return map;
	}
}
