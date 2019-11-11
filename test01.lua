include "sdc"
include "redis"

VERSION="2.0.0"
SLOG_CLASS = "ERROR"

ORDERDB_SERVICE_ID = 4

function getArea(cardPhone)
    cardPhone = cardPhone .. ""
    debugf("phone: %s", cardPhone)
    if #cardPhone == 13 then
        return string.sub(cardPhone, 0, 6)
    end

    if #cardPhone == 15 then
        return string.sub(cardPhone, 0, 8)
    end
end


function httpGet( argt )
  infof("******Http-Get-Test******" )
    local cardPhone = 861410307265852
    local area = getArea(cardPhone);


    local selectUserOrder = "SELECT uo.id,uo.service_id,uo.`mutex`,uo.priority FROM user_order_%s uo WHERE uo.card_phone = '%s' and uo.state =1"
    local r = sdc.sqlSelect(ORDERDB_SERVICE_ID, selectUserOrder, area, cardPhone)
    infof(r)
    if (r.Retn ~= "0000") then
       return sendAck({Retn = 500, Desc = "Fail"}, {"Http Get Test SQL Fail !"})
    else 
       return sendAck({Retn = 200, Desc = "OK"}, {"Http Get Test Success!"})
    end
end


function httpPost( argt )
  infof("******Http-Post-Test******" ) 
  return sendAck({Retn = 200, Desc = "OK"}, {"Http Post Test Success!"} )
end

function httpPut( argt )
  infof("******Http-Put-Test******" )
   return sendAck({Retn = 200, Desc = "OK"}, {"Http Put Test Success!"})
end


function httpDelete( argt )
  infof("******Http-Delete-Test******" )
  return sendAck({Retn = 200, Desc = "OK"}, {"Http Delete Test Success!"} )
end

function httpCmd( argt )
  infof("******Http-Cmd-Test******" )
  return sendAck({Retn = 200, Desc = "OK"}, {"Get v2 Api  Success!"} )
end

function httpAck1( argt )
    infof("******Http-Ack1-Test******" )
    return sendAck({Retn = 200, Desc = "OK"})
end

function httpAck2( argt )
    infof("******Http-Ack2-Test******" )
    return sendAck({Retn = 200, Desc = "OK"}, {"Http Ack2 Test Success!"} )
end

function httpAck3( argt )
    infof("******Http-Ack3-Test******" )
    return sendAck({Retn = 200, Desc = "OK", HttpHeader = {TEST = "Ack3"}}, {"Http Ack3 Test Success!"} )
end

function callProducer( argt )
    infof("******Call-Service-Test******" )
    local r = callSmp("test02", "/producerService", {Info="Call slTest02 Producer Service"})
    return sendAck({Retn=r.Retn, Desc=r.Desc}, {"Call Service Test Success!"} )
end

function callHttp( argt )
  infof("******Call-Http-Test******" )
  local r = callSmp("CALLHTTP@httptest_plat", "/", {Info="Call Http-Service"})
  return sendAck({Retn=r.Retn, Desc=r.Desc}, {"Call Http-Service Test Success!"} )
end




lib_cmdtable["GET /api/httpGet"] = httpGet
lib_cmdtable["POST /api/httpPost"] = httpPost
lib_cmdtable["PUT /api/httpPut"] = httpPut
lib_cmdtable["DELETE /api/httpDelete"] = httpDelete
lib_cmdtable["/api/httpCmd"] = httpCmd
lib_cmdtable["/api/httpAck1"] = httpAck1
lib_cmdtable["/api/httpAck2"] = httpAck2
lib_cmdtable["/api/httpAck3"] = httpAck3
lib_cmdtable["/api/callProducer"] = callProducer
lib_cmdtable["/api/callHttp"] = callHttp
