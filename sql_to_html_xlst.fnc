create or replace function sql_to_html_xslt(p_sql in varchar2, p_title varchar2 default null)
  return clob as
  /*
  Copyright DarkAthena(darkathena@qq.com)

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
  */
  /* author:DarkAthena
     name:query sql to a html-table  (with xslt)
     date:2021-10-28
     EMAIL:darkathena@qq.com

      example 1:
     select sql_to_html_xslt(Q'{select * from job_history}') html_table
     from dual;

     example 2:
     select sql_to_html_xslt(Q'{select * from job_history}','this is title') html_table
     from dual;

   */
  l_ctx                    dbms_xmlgen.ctxhandle;
  l_num_rows               pls_integer;
  l_xml                    xmltype;
  l_html                   xmltype;
  l_returnvalue            clob;
  l_xml_to_html_stylesheet varchar2(4000);
  l_css                    varchar2(4000);
begin
  l_xml_to_html_stylesheet := q'^<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
    <table border="1">
    <xsl:apply-templates select="ROWSET/ROW[1]" />
    </table>
    </xsl:template>
    <xsl:template match="ROW">
    <tr><xsl:apply-templates mode="th" /></tr>
    <xsl:apply-templates select="../ROW" mode="td" />
    </xsl:template>
    <xsl:template match="ROW/*" mode="th">
    <th><xsl:value-of select="local-name()" /></th>
    </xsl:template>
    <xsl:template match="ROW" mode="td">
    <tr><xsl:apply-templates /></tr>
    </xsl:template>
    <xsl:template match="ROW/*">
    <td><xsl:apply-templates /></td>
    </xsl:template>
    </xsl:stylesheet>^';

  l_css := '<style type=''text/css''>
    body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
    p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
    table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;}
    th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; padding:0px 0px 0px 0px;}
    h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;}
    h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;}
    a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;}
    </style>'; ---CSS ---- from SQLPLUS spool html style

  l_returnvalue := '<!DOCTYPE HTML><html><head><body>' || l_css || '<h1>' ||
                   p_title || '</h1>';

  l_ctx := dbms_xmlgen.newcontext(p_sql);
  dbms_xmlgen.setnullhandling(l_ctx, dbms_xmlgen.empty_tag);
  l_xml := dbms_xmlgen.getxmltype(l_ctx, dbms_xmlgen.none);
  --dbms_output.put_line(l_xml.getClobVal());
  l_num_rows := dbms_xmlgen.getnumrowsprocessed(l_ctx);
  dbms_xmlgen.closecontext(l_ctx);
  if l_num_rows > 0 then
    l_html := l_xml.transform(xmltype(l_xml_to_html_stylesheet));
    dbms_lob.append(l_returnvalue, l_html.getclobval());
  end if;
  dbms_lob.append(l_returnvalue, '</body>' || chr(10) || '</html>');
  return l_returnvalue;
exception
  when others then
    raise;
end;
/
