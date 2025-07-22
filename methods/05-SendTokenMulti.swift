<?php
                    
function SendTokenMulti($TemplateKey , $Destination , $UserTraceId , $Parameters ){
$ApiKey = "e883424d-d70f-4e58-8ee3-4e21ea390ff1";
class Recipients{
    public $Destination;
    public $UserTraceId;
    public $Parameters;
}
$Recipient = new Recipients();
$Recipient->Destination = $Destination;
$Recipient->UserTraceId = $UserTraceId;
$Recipient->Parameters = $Parameters;

$Recipients = array($Recipient);




$data = array(
    'ApiKey'=>$ApiKey,
    'TemplateKey'=>$TemplateKey,
    'Recipients'=>$Recipients
);
$data_json = json_encode($data);

$url = 'http://api.sms-webservice.com/api/V3/SendTokenMulti';
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS,$data_json);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response  = curl_exec($ch);
curl_close($ch);
return $response;
}
