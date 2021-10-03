CREATE OR REPLACE FUNCTION SQL_TO_HTML(O_ERROR_MESSAGE IN OUT VARCHAR2,
                                       l_sql           IN varchar2,
                                       l_text          OUT clob,
                                       l_head IN varchar2)
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
          /*DarkAthena 
            查询语句转HTML程序   
            2015-08-06
            EMAIL:darkathena@qq.com
          
           1.L_HEAD为标题
           2.L_SQL为查询语句，注意，查询结果中的任意字段都不能为空，若原始数据有空值，请使用NVL函数填充任意非空值
           3.L_TEXL为输出格式化的HTML文本*/
  RETURN BOOLEAN IS
  cur_ SYS_REFCURSOR;
  l_null number;
  l_ct number;
  CURSOR get_columns IS
    SELECT t2.column_value.getrootelement() name,
           EXTRACTVALUE(t2.column_value, 'node()') VALUE
      FROM (SELECT * FROM TABLE(XMLSEQUENCE(cur_))) t1,
           TABLE(XMLSEQUENCE(EXTRACT(t1.column_value, '/ROW/node()'))) t2;
            pragma  autonomous_transaction;

 
BEGIN

  --l_sql  := 'select loc ,att1 ,att2  from data_info t where att2 is not null ';
  --l_head := '标题';
 OPEN cur_ FOR 'select 1 from ('||l_sql||') where rownum=1';
 fetch cur_ into l_null;
 if  cur_%notfound then
  L_TEXT := NULL;
  return true;
   end if;

  L_TEXT := NULL;
  L_TEXT := '<!DOCTYPE HTML><html><head>
<body>' ||
           ---CSS样式----来自SQLPLUS
            '<style type=''text/css''>
             body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
             p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
             table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;}
             th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; padding:0px 0px 0px 0px;}
             h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;}
             h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;}
             a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;}
             </style>'

            || '<h1>' || l_head || '</h1>
<table border="1" >
'; ---表格边框定义
  l_ct   := 0;
  L_TEXT := L_TEXT || '<tr>
';
  OPEN cur_ FOR 'select * from (' || l_sql || ') where rownum=1';---取一行记录用于取字段名

  FOR rec_ IN get_columns LOOP
    L_TEXT := L_TEXT || '<th>' || rec_.name || '</th>';
    l_ct   := l_ct + 1;
    -- DBMS_OUTPUT.put_line(rec_.name );
  END LOOP;
  L_TEXT := L_TEXT || '
</tr>';

  OPEN cur_ FOR l_sql;  ---开始获得表体数据

  FOR rec_ IN get_columns LOOP
    if mod(get_columns %ROWCOUNT, l_ct) = 1 then
      L_TEXT := L_TEXT || '
   <tr>';
    end if;
    L_TEXT := L_TEXT || '<td>' || rec_.value || '</td>';
    --  dbms_output.put_line(to_char(get_columns %ROWCOUNT));
    if mod(get_columns %ROWCOUNT, l_ct) = 0 then
      L_TEXT := L_TEXT || '
    </tr>';
    end if;
    -- DBMS_OUTPUT.put_line(rec_.value );
  END LOOP;
  L_TEXT := L_TEXT || '
   </table>
</body>
</html>
';
rollback;
---INSERT INTO HTML_CLOB_TMP(TEXT) VALUES (L_TEXT);

  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
   O_error_message := 'FUNCTION_ERROR: '|| SQLERRM|| '; SQL_TO_HTML ;'|| to_char(SQLCODE);
    RETURN FALSE;
END;
/
