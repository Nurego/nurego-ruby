<h3>Overview</h3><br>Nurego-Ruby is simple Ruby bindings library allows easy access to Nurego system, without any hassle of dealing with REST APIs and object mapping. Each object in the system has its own Ruby representation. There are relationships between some of them and they can be traversed using Nurego-Ruby API. The following objects can be used by the customers of Nurego-Ruby:<br><ul><li>Bill</li><li>Connector</li><li>Customer</li><li>Entitlement</li><li>Feature</li><li>Instance</li><li>Offering</li><li>Organization</li><li>Password Reset</li><li>Payment Method</li><li>Plan</li><li>Registration</li></ul>Some of the objects allow simple CRUD (or subset of it), when the others hide more complex operations like password reset. <br><br><h3>Initialization</h3>
<pre><span style="color:#400000; ">require</span> “nurego”
Nurego<span style="color:#308080; ">.</span>api_key <span style="color:#308080; ">=</span> “l230bc7b<span style="color:#308080; ">-</span>9b85<span style="color:#308080; ">-</span>4c5f<span style="color:#308080; ">-</span>ad9f<span style="color:#308080; ">-</span>4eeeef4d4f44”
</pre><br>Your API key can be obtained from Settings/Organization<br><h3>Authorization</h3><br>Some of the operations require customer login (TBD)<br><br><h3>Error handling</h3><br>Several errors can be thrown by the library. The base class for all Nurego errors is Nurego::NuregoError<br><br>Additional error that can be thrown by the library are:<br><br>Nurego::APIConnectionError - failed to connect to the Nurego API endpoing<br>Nurego::APIErrror - bad response from API endpoint<br>Nurego::CardError - invalid token was provided<br>Nurego::UserNotFoundError - user not found<br>Nurego::InvalidRequestError - the request to the API endpoint was bad or had wrong arguments<br>Nurego::AuthenticationError - bad API key or username/password was provided<br><h3><br>Entitlement</h3><br>    	To use an entitlement object you need to obtain customer external ID. In case of Stripe it will be Stripe customer ID (guid starting with cus_<br><br>Get entitlement for customer<br><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(0, 0, 0); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 19.600000381469727px; white-space: normal;">﻿</span><span style="font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; color: rgb(32, 0, 128);">begin</span>
  Nureg<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”

  Nurego<span style="color: rgb(48, 128, 128);">.</span>login<span style="color: rgb(48, 128, 128);">(</span>username, password<span style="color: rgb(48, 128, 128);">)</span>

  customer <span style="color: rgb(48, 128, 128);">=</span> Nurego::Customer<span style="color: rgb(48, 128, 128);">.</span>me
  organization <span style="color: rgb(48, 128, 128);">=</span> customer<span style="color: rgb(48, 128, 128);">.</span>organizations<span style="color: rgb(48, 128, 128);">[</span><span style="color: rgb(0, 140, 0);">0</span><span style="color: rgb(48, 128, 128);">]</span>
  ents <span style="color: rgb(48, 128, 128);">=</span> organization<span style="color: rgb(48, 128, 128);">.</span>entitlements<span style="color: rgb(48, 128, 128);">(</span><span style="color: rgb(32, 0, 128); font-weight: bold;">nil</span>, customer_id<span style="color: rgb(48, 128, 128);">)</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">rescue</span> Nurego::NuregoError <span style="color: rgb(48, 128, 128);">=</span>&gt; e
  <span style="color: rgb(64, 0, 0);">puts</span> “Got exception <span style="color: rgb(89, 89, 121);">#{e}”</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;"><span style="color: rgb(16, 96, 182);">﻿</span><span style="font-family: monospace; font-size: 12px; font-style: normal; font-variant: normal; color: rgb(48, 128, 128);">[</span><span style="font-family: monospace; font-size: 12px; font-style: normal; font-variant: normal; color: rgb(89, 89, 121);">#&lt;Nurego::NuregoObject:0x18b83b8&gt; JSON: {</span><span style="color: rgb(16, 96, 182);">
 "id"</span>: <span style="color: rgb(16, 96, 182);">"dba33a54-57dc-4a29-abf7-0a83aa7c1961"</span>,
 <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"entitlement"</span>,
 <span style="color: rgb(16, 96, 182);">"feature_name"</span>: <span style="color: rgb(16, 96, 182);">"subscribers"</span>,
 <span style="color: rgb(16, 96, 182);">"max_allowed_amount"</span>: <span style="color: rgb(0, 140, 0);">10</span>
}<span style="color: rgb(48, 128, 128);">]</span></pre><br>Get entitlements for customer and feature<br><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(32, 0, 128); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">begin</span>
  Nureg<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”

  Nurego<span style="color: rgb(48, 128, 128);">.</span>login<span style="color: rgb(48, 128, 128);">(</span>username, password<span style="color: rgb(48, 128, 128);">)</span>

  customer <span style="color: rgb(48, 128, 128);">=</span> Nurego::Customer<span style="color: rgb(48, 128, 128);">.</span>me
  organization <span style="color: rgb(48, 128, 128);">=</span> customer<span style="color: rgb(48, 128, 128);">.</span>organizations<span style="color: rgb(48, 128, 128);">[</span><span style="color: rgb(0, 140, 0);">0</span><span style="color: rgb(48, 128, 128);">]</span>
  ents <span style="color: rgb(48, 128, 128);">=</span> organization<span style="color: rgb(48, 128, 128);">.</span>entitlements<span style="color: rgb(48, 128, 128);">(</span>feature_id, customer_id<span style="color: rgb(48, 128, 128);">)</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">rescue</span> Nurego::NuregoError <span style="color: rgb(48, 128, 128);">=</span>&gt; e
  <span style="color: rgb(64, 0, 0);">puts</span> “Got exception <span style="color: rgb(89, 89, 121);">#{e}”</span>

<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><br>Submit usage for customer<br><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(32, 0, 128); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">begin</span>
  Nureg<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”

  Nurego<span style="color: rgb(48, 128, 128);">.</span>login<span style="color: rgb(48, 128, 128);">(</span>username, password<span style="color: rgb(48, 128, 128);">)</span>

  ent <span style="color: rgb(48, 128, 128);">=</span> Nurego::Entitlement<span style="color: rgb(48, 128, 128);">.</span><span style="color: rgb(32, 0, 128); font-weight: bold;">new</span><span style="color: rgb(48, 128, 128);">(</span><span style="color: rgb(64, 96, 128);">{</span>id: customer_id<span style="color: rgb(64, 96, 128);">}</span><span style="color: rgb(48, 128, 128);">)</span>
  ent<span style="color: rgb(48, 128, 128);">.</span>set_usage<span style="color: rgb(48, 128, 128);">(</span>feature_id, max_amount <span style="color: rgb(48, 128, 128);">-</span> <span style="color: rgb(0, 140, 0);">1</span><span style="color: rgb(48, 128, 128);">)</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">rescue</span> Nurego::NuregoError <span style="color: rgb(48, 128, 128);">=</span>&gt; e
  <span style="color: rgb(64, 0, 0);">puts</span> “Got exception <span style="color: rgb(89, 89, 121);">#{e}”</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><br>Check allowed usage for customer<br><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(0, 0, 0); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 19.600000381469727px; white-space: normal;">﻿</span><span style="font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; color: rgb(32, 0, 128);">begin</span>
  Nureg<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”

  Nurego<span style="color: rgb(48, 128, 128);">.</span>login<span style="color: rgb(48, 128, 128);">(</span>username, password<span style="color: rgb(48, 128, 128);">)</span>

  customer <span style="color: rgb(48, 128, 128);">=</span> Nurego::Customer<span style="color: rgb(48, 128, 128);">.</span>me
  organization <span style="color: rgb(48, 128, 128);">=</span> customer<span style="color: rgb(48, 128, 128);">.</span>organizations<span style="color: rgb(48, 128, 128);">[</span><span style="color: rgb(0, 140, 0);">0</span><span style="color: rgb(48, 128, 128);">]</span>
  ents <span style="color: rgb(48, 128, 128);">=</span> organization<span style="color: rgb(48, 128, 128);">.</span>entitlements<span style="color: rgb(48, 128, 128);">(</span>feature_id, customer_id<span style="color: rgb(48, 128, 128);">)</span>
  ent <span style="color: rgb(48, 128, 128);">=</span> ents<span style="color: rgb(48, 128, 128);">[</span><span style="color: rgb(0, 140, 0);">0</span><span style="color: rgb(48, 128, 128);">]</span>


  allowed <span style="color: rgb(48, 128, 128);">=</span> ent<span style="color: rgb(48, 128, 128);">.</span>is_allowed<span style="color: rgb(48, 128, 128);">(</span>feature_id, <span style="color: rgb(0, 140, 0);">1</span><span style="color: rgb(48, 128, 128);">)</span>
  <span style="color: rgb(64, 0, 0);">puts</span> <span style="color: rgb(16, 96, 182);">"#{allowed.inspect}"</span>

  allowed <span style="color: rgb(48, 128, 128);">=</span> ent<span style="color: rgb(48, 128, 128);">.</span>is_allowed<span style="color: rgb(48, 128, 128);">(</span>feature_id, <span style="color: rgb(0, 140, 0);">2</span><span style="color: rgb(48, 128, 128);">)</span>
  <span style="color: rgb(64, 0, 0);">puts</span> <span style="color: rgb(16, 96, 182);">"#{allowed.inspect}"</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">rescue</span> Nurego::NuregoError <span style="color: rgb(48, 128, 128);">=</span>&gt; e
  <span style="color: rgb(64, 0, 0);">puts</span> “Got exception <span style="color: rgb(89, 89, 121);">#{e}”</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><h3>Feature</h3><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(32, 0, 128); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">begin</span>
  Nurego<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”
  offering <span style="color: rgb(48, 128, 128);">=</span> Nurego::Offering<span style="color: rgb(48, 128, 128);">.</span>current
  offering<span style="color: rgb(48, 128, 128);">.</span>plans<span style="color: rgb(48, 128, 128);">.</span><span style="color: rgb(32, 0, 128); font-weight: bold;">each</span> <span style="color: rgb(32, 0, 128); font-weight: bold;">do</span> |plan|
  <span style="color: rgb(64, 0, 0);">puts</span> plan<span style="color: rgb(48, 128, 128);">.</span>inspect
  plan<span style="color: rgb(48, 128, 128);">.</span>features<span style="color: rgb(48, 128, 128);">.</span><span style="color: rgb(32, 0, 128); font-weight: bold;">each</span> <span style="color: rgb(32, 0, 128); font-weight: bold;">do</span> |feature|
    <span style="color: rgb(64, 0, 0);">puts</span> feature<span style="color: rgb(48, 128, 128);">.</span>inspect
  <span style="color: rgb(32, 0, 128); font-weight: bold;">end</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><br>Response will look like this<br><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(89, 89, 121); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">#&lt;Nurego::Feature:0x1285518&gt; JSON: {</span>
 <span style="color: rgb(16, 96, 182);">"id"</span>: <span style="color: rgb(16, 96, 182);">"id"</span>,
  <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
  <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Funds Service"</span>,
  <span style="color: rgb(16, 96, 182);">"element_type"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
  <span style="color: rgb(16, 96, 182);">"price"</span>: <span style="color: rgb(0, 128, 0);">0.0</span>,
  <span style="color: rgb(16, 96, 182);">"min_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
  <span style="color: rgb(16, 96, 182);">"max_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
  <span style="color: rgb(16, 96, 182);">"period"</span>: <span style="color: rgb(16, 96, 182);">"monthly"</span>,
  <span style="color: rgb(16, 96, 182);">"billing_period_interval"</span>: <span style="color: rgb(0, 140, 0);">1</span>,
  <span style="color: rgb(16, 96, 182);">"unit_type"</span>: <span style="color: rgb(64, 96, 128);">{</span><span style="color: rgb(16, 96, 182);">"name"</span>:<span style="color: rgb(16, 96, 182);">"Funds Service"</span>,<span style="color: rgb(16, 96, 182);">"consumable"</span>:<span style="color: rgb(32, 0, 128); font-weight: bold;">false</span>,<span style="color: rgb(16, 96, 182);">"apply_repetition"</span>:<span style="color: rgb(0, 140, 0);">0</span>,<span style="color: rgb(16, 96, 182);">"guid"</span>:<span style="color: rgb(16, 96, 182);">"cd96f327-e1e1-4081-8717-a5baaae4984e"</span><span style="color: rgb(64, 96, 128);">}</span>
}</pre><h3>Offering</h3>Retrieve the current offering for the 'All' segment through the 'website' distribution channel.<pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(32, 0, 128); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">begin</span>
  Nurego<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”
  offering <span style="color: rgb(48, 128, 128);">=</span> Nurego::Offering<span style="color: rgb(48, 128, 128);">.</span>current
<span style="color: rgb(64, 0, 0);">  puts</span> offering<span style="color: rgb(48, 128, 128);">.</span>inspect
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><br>To retrieve offerings available for a particular segment and/or distribution channel, add the optional ```:segment_guid``` and/or ```:distribution_channel``` parameters. To learn more about segments and distribution channels, take a look at the [documentation](http://nurego.com/documentation) <pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(32, 0, 128); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">begin</span>
  Nurego<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”
  offering <span style="color: rgb(48, 128, 128);">=</span> Nurego::Offering<span style="color: rgb(48, 128, 128);">.</span>current
<span style="color: rgb(64, 0, 0);">  puts</span> offering<span style="color: rgb(48, 128, 128);">.</span>inspect
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre>﻿<span style="font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 19.600000381469727px;">Response will look like this</span><br><pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;"><span style="color: rgb(16, 96, 182);">﻿</span><span style="color: rgb(89, 89, 121); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">#&lt;Nurego::ListObject:0x1412db8&gt; JSON: {</span><span style="color: rgb(16, 96, 182);">
"data"</span>: <span style="color: rgb(48, 128, 128);">[</span>
<span style="color: rgb(64, 96, 128);">{</span>
  <span style="color: rgb(16, 96, 182);">"id"</span>: <span style="color: rgb(16, 96, 182);">"ce24d45f-4b33-41d3-a3cb-d46ad411c086"</span>,
  <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"plan"</span>,
  <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Entry Level"</span>,
  <span style="color: rgb(16, 96, 182);">"description"</span>: null,
  <span style="color: rgb(16, 96, 182);">"plan_status"</span>: <span style="color: rgb(16, 96, 182);">"active"</span>,
  <span style="color: rgb(16, 96, 182);">"credit_card"</span>: <span style="color: rgb(32, 0, 128); font-weight: bold;">false</span>,
  <span style="color: rgb(16, 96, 182);">"plan_order"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
  <span style="color: rgb(16, 96, 182);">"discounts"</span>: <span style="color: rgb(48, 128, 128);">[</span>
    
  <span style="color: rgb(48, 128, 128);">]</span>,
  <span style="color: rgb(16, 96, 182);">"features"</span>: <span style="color: rgb(64, 96, 128);">{</span>
    <span style="color: rgb(16, 96, 182);">"data"</span>: <span style="color: rgb(48, 128, 128);">[</span>
      <span style="color: rgb(64, 96, 128);">{</span>
        <span style="color: rgb(16, 96, 182);">"id"</span>: <span style="color: rgb(16, 96, 182);">"id"</span>,
        <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Email Support"</span>,
        <span style="color: rgb(16, 96, 182);">"element_type"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"price"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"min_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"max_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"period"</span>: <span style="color: rgb(16, 96, 182);">"monthly"</span>,
        <span style="color: rgb(16, 96, 182);">"billing_period_interval"</span>: <span style="color: rgb(0, 140, 0);">1</span>,
        <span style="color: rgb(16, 96, 182);">"unit_type"</span>: <span style="color: rgb(64, 96, 128);">{</span>
          <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Email Support"</span>,
          <span style="color: rgb(16, 96, 182);">"consumable"</span>: <span style="color: rgb(32, 0, 128); font-weight: bold;">false</span>,
          <span style="color: rgb(16, 96, 182);">"apply_repetition"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
          <span style="color: rgb(16, 96, 182);">"guid"</span>: <span style="color: rgb(16, 96, 182);">"dba33a54-57dc-4a29-abf7-0a83aa7c1961"</span>
        <span style="color: rgb(64, 96, 128);">}</span>
      <span style="color: rgb(64, 96, 128);">}</span>,
      <span style="color: rgb(64, 96, 128);">{</span>
        <span style="color: rgb(16, 96, 182);">"id"</span>: <span style="color: rgb(16, 96, 182);">"id"</span>,
        <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Financial News Service"</span>,
        <span style="color: rgb(16, 96, 182);">"element_type"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"price"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"min_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"max_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"period"</span>: <span style="color: rgb(16, 96, 182);">"monthly"</span>,
        <span style="color: rgb(16, 96, 182);">"billing_period_interval"</span>: <span style="color: rgb(0, 140, 0);">1</span>,
        <span style="color: rgb(16, 96, 182);">"unit_type"</span>: <span style="color: rgb(64, 96, 128);">{</span>
          <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Financial News Service"</span>,
          <span style="color: rgb(16, 96, 182);">"consumable"</span>: <span style="color: rgb(32, 0, 128); font-weight: bold;">false</span>,
          <span style="color: rgb(16, 96, 182);">"apply_repetition"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
          <span style="color: rgb(16, 96, 182);">"guid"</span>: <span style="color: rgb(16, 96, 182);">"7de73a31-db39-4aa7-a8c2-8c1d325ec080"</span>
        <span style="color: rgb(64, 96, 128);">}</span>
      <span style="color: rgb(64, 96, 128);">}</span>,
      <span style="color: rgb(64, 96, 128);">{</span>
        <span style="color: rgb(16, 96, 182);">"id"</span>: <span style="color: rgb(16, 96, 182);">"id"</span>,
        <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Indices Services"</span>,
        <span style="color: rgb(16, 96, 182);">"element_type"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"price"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"min_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"max_unit"</span>: <span style="color: rgb(0, 140, 0);">2</span>,
        <span style="color: rgb(16, 96, 182);">"period"</span>: <span style="color: rgb(16, 96, 182);">"monthly"</span>,
        <span style="color: rgb(16, 96, 182);">"billing_period_interval"</span>: <span style="color: rgb(0, 140, 0);">1</span>,
        <span style="color: rgb(16, 96, 182);">"unit_type"</span>: <span style="color: rgb(64, 96, 128);">{</span>
          <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"Indices Services"</span>,
          <span style="color: rgb(16, 96, 182);">"consumable"</span>: <span style="color: rgb(32, 0, 128); font-weight: bold;">false</span>,
          <span style="color: rgb(16, 96, 182);">"apply_repetition"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
          <span style="color: rgb(16, 96, 182);">"guid"</span>: <span style="color: rgb(16, 96, 182);">"65531b5f-a1af-474e-8709-65f49b6c6ad8"</span>
        <span style="color: rgb(64, 96, 128);">}</span>
      <span style="color: rgb(64, 96, 128);">}</span>,
      <span style="color: rgb(64, 96, 128);">{</span>
        <span style="color: rgb(16, 96, 182);">"id"</span>: <span style="color: rgb(16, 96, 182);">"id"</span>,
        <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"feature"</span>,
        <span style="color: rgb(16, 96, 182);">"name"</span>: <span style="color: rgb(16, 96, 182);">"recurring"</span>,
        <span style="color: rgb(16, 96, 182);">"element_type"</span>: <span style="color: rgb(16, 96, 182);">"recurring"</span>,
        <span style="color: rgb(16, 96, 182);">"price"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"min_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"max_unit"</span>: <span style="color: rgb(0, 140, 0);">0</span>,
        <span style="color: rgb(16, 96, 182);">"period"</span>: <span style="color: rgb(16, 96, 182);">"monthly"</span>,
        <span style="color: rgb(16, 96, 182);">"billing_period_interval"</span>: <span style="color: rgb(0, 140, 0);">1</span>
      <span style="color: rgb(64, 96, 128);">}</span>
    <span style="color: rgb(48, 128, 128);">]</span>,
    <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"list"</span>,
    <span style="color: rgb(16, 96, 182);">"count"</span>: <span style="color: rgb(0, 140, 0);">4</span>,
    <span style="color: rgb(16, 96, 182);">"url"</span>: <span style="color: rgb(16, 96, 182);">"\/v1\/plans\/ce24d45f-4b33-41d3-a3cb-d46ad411c086\/features"</span>
  <span style="color: rgb(64, 96, 128);">}</span>
<span style="color: rgb(64, 96, 128);">}</span>
<span style="color: rgb(48, 128, 128);">]</span>,
  <span style="color: rgb(16, 96, 182);">"object"</span>: <span style="color: rgb(16, 96, 182);">"list"</span>,
  <span style="color: rgb(16, 96, 182);">"count"</span>: <span style="color: rgb(0, 140, 0);">1</span>,
  <span style="color: rgb(16, 96, 182);">"url"</span>: <span style="color: rgb(16, 96, 182);">"/v1/offerings/013ddd26-131d-43f9-95e3-790111a91dad/plans"</span>
}</pre><h3>Plan</h3>﻿The ```:distribution_channel``` and ```:segment_guid``` params are optional. Use them to call plans for a specific distribution channel and/or segment. To learn more about creating segments and distribution channels, check out the [documentation](http://nurego.com/documentation)<pre style="color: rgb(0, 0, 32); font-size: medium; font-style: normal; font-variant: normal; line-height: normal;">﻿<span style="color: rgb(32, 0, 128); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant: normal; line-height: 14px;">begin</span>
  Nurego<span style="color: rgb(48, 128, 128);">.</span>api_key <span style="color: rgb(48, 128, 128);">=</span> “l230bc7b<span style="color: rgb(48, 128, 128);">-</span>9b85<span style="color: rgb(48, 128, 128);">-</span>4c5f<span style="color: rgb(48, 128, 128);">-</span>ad9f<span style="color: rgb(48, 128, 128);">-</span>4eeeef4d4f44”
  offering <span style="color: rgb(48, 128, 128);">=</span> Nurego::Offering<span style="color: rgb(48, 128, 128);">.</span>current({:segment_guid => '', :distribution_channel => '<CHANNEL>'})

  offering<span style="color: rgb(48, 128, 128);">.</span>plans<span style="color: rgb(48, 128, 128);">.</span><span style="color: rgb(32, 0, 128); font-weight: bold;">each</span> <span style="color: rgb(32, 0, 128); font-weight: bold;">do</span> |plan|
    <span style="color: rgb(64, 0, 0);">puts</span> plan<span style="color: rgb(48, 128, 128);">.</span>inspect
  <span style="color: rgb(32, 0, 128); font-weight: bold;">end</span>
<span style="color: rgb(32, 0, 128); font-weight: bold;">end</span></pre><h3>Registration</h3><br>﻿<div></div>
