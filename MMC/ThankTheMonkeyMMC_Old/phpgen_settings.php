<?php

//  define('SHOW_VARIABLES', 1);
//  define('DEBUG_LEVEL', 1);

//  error_reporting(E_ALL ^ E_NOTICE);
//  ini_set('display_errors', 'On');

set_include_path('.' . PATH_SEPARATOR . get_include_path());


require_once 'components/utils/system_utils.php';

//  SystemUtils::DisableMagicQuotesRuntime();

SystemUtils::SetTimeZoneIfNeed('America/New_York');

function GetGlobalConnectionOptions()
{
    return array(
  'database' => '../ThankTheMonkey.sqlite'
);
}

function HasAdminPage()
{
    return false;
}

function GetPageInfos()
{
    $result = array();
    $result[] = array('caption' => 'Business', 'short_caption' => 'Business', 'filename' => 'Business.php', 'name' => 'Business');
    $result[] = array('caption' => 'BusinessType', 'short_caption' => 'BusinessType', 'filename' => 'BusinessType.php', 'name' => 'BusinessType');
    $result[] = array('caption' => 'Location', 'short_caption' => 'Location', 'filename' => 'Location.php', 'name' => 'Location');
    $result[] = array('caption' => 'Market', 'short_caption' => 'Market', 'filename' => 'Market.php', 'name' => 'Market');
    $result[] = array('caption' => 'MediaPartner', 'short_caption' => 'MediaPartner', 'filename' => 'MediaPartner.php', 'name' => 'MediaPartner');
    $result[] = array('caption' => 'Coupon', 'short_caption' => 'Coupon', 'filename' => 'Coupon.php', 'name' => 'Coupon');
    return $result;
}

function GetPagesHeader()
{
    return
    '';
}

function GetPagesFooter()
{
    return
        ''; 
    }

function ApplyCommonPageSettings($page, $grid)
{
    $page->SetShowUserAuthBar(false);
    $grid->BeforeUpdateRecord->AddListener('Global_BeforeUpdateHandler');
    $grid->BeforeDeleteRecord->AddListener('Global_BeforeDeleteHandler');
    $grid->BeforeInsertRecord->AddListener('Global_BeforeInsertHandler');
}

/*
  Default code page: 1252
*/
function GetAnsiEncoding() { return 'windows-1252'; }

function Global_BeforeUpdateHandler($page, $rowData, &$cancel, &$message, $tableName)
{

}

function Global_BeforeDeleteHandler($page, $rowData, &$cancel, &$message, $tableName)
{

}

function Global_BeforeInsertHandler($page, $rowData, &$cancel, &$message, $tableName)
{

}

function GetDefaultDateFormat()
{
    return 'Y-m-d';
}
?>
