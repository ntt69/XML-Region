prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the owner (parsing schema)
-- of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.2'
,p_default_workspace_id=>8292847022522294
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'WKSP_PRVI'
);
end;
/
 
prompt APPLICATION 102 - XML Demo
--
-- Application Export:
--   Application:     102
--   Name:            XML Demo
--   Date and Time:   12:05 Thursday March 2, 2023
--   Exported By:     DRUGI
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 11339481362745905
--   Manifest End
--   Version:         22.2.2
--   Instance ID:     8292705724139411
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/rs_nenadt_xmlregion
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(11339481362745905)
,p_plugin_type=>'REGION TYPE'
,p_name=>'RS.NENADT.XMLREGION'
,p_display_name=>'XML Region'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render_xml_region (',
'    p_region              in apex_plugin.t_region,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_region_render_result',
'IS',
'    i                     PLS_INTEGER := 1;',
'    l_chunk_sz CONSTANT   PLS_INTEGER := 8000;',
'    l_xml                 XMLTYPE;',
'    l_clob                CLOB;',
'    l_return apex_plugin.t_region_render_result;',
'    l_style CONSTANT      XMLTYPE := XMLTYPE(q''[',
'<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">',
'<xsl:output method="html" indent="yes" />',
'<xsl:template match="*[*]">',
'<xsl:variable name="ime" select="local-name()" /> ',
'  <li>',
'  <xsl:attribute name="class">',
'    <xsl:value-of select="$ime" />',
'  </xsl:attribute>',
'  <ul>',
'      <xsl:value-of select="$ime" />',
'      <xsl:apply-templates select="@*" />',
'      <xsl:apply-templates />',
'    </ul>',
'  </li>',
'</xsl:template>',
'<xsl:template match="*[not(*)]">',
'  <li>',
'    <xsl:value-of select="local-name()" />',
'    <xsl:apply-templates select="@*" />',
'    <b><xsl:value-of select="."/></b>',
'  </li>',
'</xsl:template>',
'',
'<xsl:template match="@*">',
'  <i><xsl:value-of select="normalize-space(.)"/></i>',
'</xsl:template>',
'',
'<xsl:template match="/*" priority="5">',
'',
'  <ul>',
'    <h2><xsl:value-of select="local-name()" /> </h2>',
'    <xsl:apply-templates select="@*" />',
'    <xsl:apply-templates />',
'  </ul>',
'</xsl:template>',
'</xsl:stylesheet>',
']'');',
'',
'BEGIN',
'    apex_plugin_util.debug_region( p_plugin, p_region );',
'    ',
'    EXECUTE IMMEDIATE p_region.source INTO l_xml USING p_region.attribute_01;',
'',
'    SELECT XMLTRANSFORM(l_xml, l_style).getclobval() INTO l_clob FROM dual;',
'',
'    --l_clob := l_xml.transform(l_style).getclobval();',
'',
'    WHILE i <= dbms_lob.getlength( l_clob ) LOOP',
'        IF p_region.escape_output THEN',
'            apex_plugin_util.print_escaped_value( dbms_lob.substr( l_clob, l_chunk_sz, i ));',
'        ELSE',
'            htp.prn( dbms_lob.substr( l_clob, l_chunk_sz, i ));',
'        END IF;',
'        i := i + l_chunk_sz;',
'    END LOOP;',
'    sys.htp.prn(q''[',
'<style> ',
'    ol, ul { margin: 0.1rem 1rem; } ',
'    b { margin-left:0.1rem } ',
'</style>',
']'');',
'    sys.htp.prn(''<style>'' || p_region.attribute_02 || ''</style>'');',
'    sys.htp.prn( CHR(13) || CHR(10) );',
'    return l_return;',
'END;',
''))
,p_api_version=>2
,p_render_function=>'render_xml_region'
,p_standard_attributes=>'SOURCE_LOCATION:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This plugin is used to display XML from database. It can be XML document stored into database or any other construct that maps to XML data type.',
'',
'In order to select proper record for displaying, SQL query is supplied together with primary key value as page item. SQL query should return only one column and one row.',
'',
'The XML structure is presented using combination of <ul>, <li> tags following natural tree structure of XML document.',
'',
'It could be useful to display any kind of hierarchical data and complex structures, for example the SQL statement could run across several relation tables with master - master - detail structure wrap it into XML structure ready to be displayed with t'
||'he plugin.',
'',
'Additionally CSS styling can be applied through CSS attribute. Non terminal <li> tags contain class attribute mapped from the name of original XML tag, making targeting of specific html areas easier.'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://g4ad903532a1ceb-dbmnh52.adb.uk-london-1.oraclecloudapps.com/ords/r/prvi/xml-demo/home'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(11344917828381777)
,p_plugin_id=>wwv_flow_imp.id(11339481362745905)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Primary Key'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>'In order to select proper record for displaying, SQL query is supplied together with primary key value as page item.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(11345503127387688)
,p_plugin_id=>wwv_flow_imp.id(11339481362745905)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'CSS'
,p_attribute_type=>'HTML'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Additionally CSS styling can be applied through CSS attribute. Non terminal <li> tags contain class attribute mapped from the name of original XML tag, making targeting of specific html areas easier.'
);
wwv_flow_imp_shared.create_plugin_std_attribute(
 p_id=>wwv_flow_imp.id(11339659649745907)
,p_plugin_id=>wwv_flow_imp.id(11339481362745905)
,p_name=>'SOURCE_LOCATION'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
