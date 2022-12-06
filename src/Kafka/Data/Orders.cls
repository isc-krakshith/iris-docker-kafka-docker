Class Kafka.Data.Orders Extends (%Library.Persistent, %Populate) [ Not Abstract, DdlAllowed, Not LegacyInstanceContext, ProcedureBlock ]
{

Property orderId As %Library.Integer(MAXVAL = 1800, MINVAL = 1) [ SqlColumnNumber = 2 ];

Property dateTime As %Library.PosixTime [ SqlColumnNumber = 3 ];

Property security As %Library.String(VALUELIST = "-SECA-SECB-SECC-SECD") [ SqlColumnNumber = 4 ];

Property vol As %Library.Integer(MAXVAL = 1500, MINVAL = 1) [ SqlColumnNumber = 5 ];

Property buy As %Library.Boolean [ SqlColumnNumber = 6 ];

Property bidAsk As %Library.Double(MAXVAL = 99, MINVAL = 25) [ Required, SqlColumnNumber = 7 ];

/// Return set of orders which can be fullfilled
ClassMethod Match(buy As %Boolean, tickerName As %String, volume As %Numeric, price As %Numeric) As %SQL.StatementResult [ ReturnResultsets, SqlProc ]
{
	#dim %sqlcontext as %ProcedureContext
	#dim resultSet as %SQL.StatementResult
	set resultSet = $$$NULLOREF
	#dim statement as %SQL.Statement
	set statement = ##class(%SQL.Statement).%New(1) // ODBC mode
    set comparisonOperator = ">="
    if buy   = 1 {
        set comparisonOperator = "<="
    }
    set sql = "SELECT * FROM KAFKA_DATA.ORDERS"
    set sql = sql _ " WHERE BUY = ? AND security = ? AND VOL >= ? AND BIDASK " _comparisonOperator_" ?" 

	set status = statement.%Prepare(sql)
	if $$$ISOK(status) {
		set resultSet = statement.%Execute(buy, tickerName, volume, price)
		if (resultSet.%SQLCODE = 0) {
			// successful %Execute

			// for testing using Terminal
			//while resultSet.%Next() {
			//	write !!, resultSet.id, ?5, resultSet.dateTime, ?35, resultSet.vol, ?40, resultSet.bidAsk
			//}

			// for xDBC
			// do %sqlcontext.AddResultSet(resultSet)
		}
		else {
			// error during %Execute
			set %sqlcontext.%SQLCODE = resultSet.%SQLCODE
			set %sqlcontext.%Message = resultSet.%Message
		} 
	}
	else {
		// error during %Prepare: bad SQL
		#dim ex as %Exception.StatusException
		set ex = ##class(%Exception.StatusException).CreateFromStatus(status)
		set %sqlcontext.%SQLCODE = ex.AsSQLCODE()
		// 4th ":" piece contains %msg value
		set %sqlcontext.%Message = $piece(ex.AsSQLMessage(), ":", 4)
	}
	return resultSet  // return results to other server-side code
}

Storage Default
{
<Data name="OrdersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>id</Value>
</Value>
<Value name="3">
<Value>dateTime</Value>
</Value>
<Value name="4">
<Value>security</Value>
</Value>
<Value name="5">
<Value>vol</Value>
</Value>
<Value name="6">
<Value>buy</Value>
</Value>
<Value name="7">
<Value>bidAsk</Value>
</Value>
<Value name="8">
<Value>orderId</Value>
</Value>
</Data>
<DataLocation>^Kafka.Data.OrdersD</DataLocation>
<DefaultData>OrdersDefaultData</DefaultData>
<ExtentSize>500</ExtentSize>
<IdLocation>^Kafka.Data.OrdersD</IdLocation>
<IndexLocation>^Kafka.Data.OrdersI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3.49</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,34,68,102,136,170,203,236,269,302,335,368,401,434,467,500),$lb(0,0,0,1,1,0,1,1,0,1,1,0,1,1,0),$lb(822083584,822083584,859045888,859045888,909639680,909639680,825242112,808583168,859176960,859176960,925892608,825700352,842019584,808648704,859176960,859176960,909705216,842414336,858796544,808583168,859111424,859111424,909639680,859191296,875573504,808517632,859045888,859045888,909574144,875968256,892350464,892350464))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="bidAsk">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb($double(25),$double(29),$double(34),$double(39),$double(45),$double(49),$double(54),$double(60),$double(64),$double(70),$double(76),$double(81),$double(86),$double(90),$double(95),$double(99)),$lb(9,8,9,8,9,8,8,9,8,9,8,9,8,9,9),$lb(842334208,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,960036864))</Histogram>
<Selectivity>1.3514%</Selectivity>
</Property>
<Property name="buy">
<AverageFieldSize>2.49</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1),$lb(1,1,1,1,1,1,1,0,1,1,1,1,1,1,1),$lb(805306368,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805306368,822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="dateTime">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(-6919732771618722584,-6919459987113950352,-6919107492954312224,-6918872768346782101,-6918647697070597806,-6918454384231764191,-6918185791005811296,-6917937007535842089,-6917659691170165908,1153116178672759697,1153353128741279248,1153548759089421529,1153721107244803382,1154021263148161447,1154255428501300122,1154582767820531982),$lb(5,5,4,5,5,5,4,5,0,4,4,4,3,4,4),$lb(758528305,926102071,875903289,875903289,825243444,959524919,943208242,943141431,909391670,909391670,875902003,875902003,825767223,942749749,926495543,959657776,909457718,758528305,825308467,825308721,859124529,859124529,892614711,892614711,926036273,859255345,875573809,808595762,842347828,842347828,892875319,825308468))</Histogram>
<Selectivity>0.2000%</Selectivity>
</Property>
<Property name="orderId">
<AverageFieldSize>3.85</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,105,227,383,501,646,746,873,959,1075,1213,1352,1471,1596,1698,1794),$lb(1,0,0,0,0,0,0,0,0,1,1,1,1,1,1),$lb(822083584,0,808779776,825242880,842151680,842151680,859321088,859321088,892350720,892350720,909391360,909391360,926168576,926168576,943141632,943141632,959789312,959789312,825243445,808924416,842085120,842085120,859124224,859124224,876032256,876032256,892941824,892941824,909719552,909719552,926495744,825702708))</Histogram>
<Selectivity>0.2294%</Selectivity>
</Property>
<Property name="security">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" SECA"," SECA"," SECA"," SECA"," SECB"," SECB"," SECB"," SECB"," SECC"," SECC"," SECC"," SECC"," SECD"," SECD"," SECD"," SECD"),$lb(6,6,6,4,6,6,6,4,6,6,6,4,6,6,6),$lb(542328131,0,0,0,0,0,0,1090519040,1107296256,0,0,0,0,0,0,1107296256,1124073472,0,0,0,0,0,0,1124073472,1140850688,0,0,0,0,0,0,542328131))</Histogram>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="vol">
<AverageFieldSize>3.86</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(8,111,252,333,428,542,681,770,868,959,1055,1146,1213,1321,1401,1499),$lb(0,0,0,0,0,0,0,0,0,0,1,1,1,1,2),$lb(939524096,939524096,825307392,825307392,842347008,842347008,858993408,858993408,875706368,875706368,892613120,892613120,909652224,909652224,926363648,926363648,943077376,943077376,959789312,959789312,825242933,808793344,825505280,825505280,842085120,842085120,858927360,858927360,875573504,808517632,960036864,825506105))</Histogram>
<Selectivity>0.2364%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-12</BlockCount>
</SQLMap>
<SQLMap name="orderIdIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^Kafka.Data.OrdersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
