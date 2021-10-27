# sql_to_html
sql查询结果转换成html表格   

a new version with PTF(ORACLE 18C)    
https://github.com/Dark-Athena/sql_to_html-oracle/blob/main/SQL_TO_HTML_PTF.pkg   

sql query convert to a html's table 

example 1:

```sql
select SQL_TO_HTML_PTF.main(Q'{select * from job_history 
union all select 1,date'2021-10-27',null,'',cast(null as number) 
from dual}') html_table  from dual;
```

```html
<!DOCTYPE HTML><html><head>
<body><style type='text/css'>
             body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
             p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
             table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;}
             th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; padding:0px 0px 0px 0px;}
             h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;}
             h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;}
             a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;}
             </style><h1></h1>
<table border="1" >
<tr>
<th>EMPLOYEE_ID</th><th>START_DATE</th><th>END_DATE</th><th>JOB_ID</th><th>DEPARTMENT_ID</th>
</tr>
   <tr><td>102</td><td>2001-01-13</td><td>2006-07-24</td><td>IT_PROG</td><td>60</td>
    </tr>
   <tr><td>101</td><td>1997-09-21</td><td>2001-10-27</td><td>AC_ACCOUNT</td><td>110</td>
    </tr>
   <tr><td>101</td><td>2001-10-28</td><td>2005-03-15</td><td>AC_MGR</td><td>110</td>
    </tr>
   <tr><td>201</td><td>2004-02-17</td><td>2007-12-19</td><td>MK_REP</td><td>20</td>
    </tr>
   <tr><td>114</td><td>2006-03-24</td><td>2007-12-31</td><td>ST_CLERK</td><td>50</td>
    </tr>
   <tr><td>122</td><td>2007-01-01</td><td>2007-12-31</td><td>ST_CLERK</td><td>50</td>
    </tr>
   <tr><td>200</td><td>1995-09-17</td><td>2001-06-17</td><td>AD_ASST</td><td>90</td>
    </tr>
   <tr><td>176</td><td>2006-03-24</td><td>2006-12-31</td><td>SA_REP</td><td>80</td>
    </tr>
   <tr><td>176</td><td>2007-01-01</td><td>2007-12-31</td><td>SA_MAN</td><td>80</td>
    </tr>
   <tr><td>200</td><td>2002-07-01</td><td>2006-12-31</td><td>AC_ACCOUNT</td><td>90</td>
    </tr>
   <tr><td>1</td><td>2021-10-27</td><td>-</td><td>-</td><td>-</td>
    </tr>
   </table>
</body>
</html>

```

example 2: 
```sql

select SQL_TO_HTML_PTF.main(Q'{select * from job_history 
union all select 1,date'2021-10-27',null,'',cast(null as number) 
from dual}',
'this is title','None value') html_table  from dual;
```

```html
<!DOCTYPE HTML><html><head>
<body><style type='text/css'>
             body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
             p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;}
             table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;}
             th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; padding:0px 0px 0px 0px;}
             h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;}
             h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;}
             a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;}
             </style><h1>this is title</h1>
<table border="1" >
<tr>
<th>EMPLOYEE_ID</th><th>START_DATE</th><th>END_DATE</th><th>JOB_ID</th><th>DEPARTMENT_ID</th>
</tr>
   <tr><td>102</td><td>2001-01-13</td><td>2006-07-24</td><td>IT_PROG</td><td>60</td>
    </tr>
   <tr><td>101</td><td>1997-09-21</td><td>2001-10-27</td><td>AC_ACCOUNT</td><td>110</td>
    </tr>
   <tr><td>101</td><td>2001-10-28</td><td>2005-03-15</td><td>AC_MGR</td><td>110</td>
    </tr>
   <tr><td>201</td><td>2004-02-17</td><td>2007-12-19</td><td>MK_REP</td><td>20</td>
    </tr>
   <tr><td>114</td><td>2006-03-24</td><td>2007-12-31</td><td>ST_CLERK</td><td>50</td>
    </tr>
   <tr><td>122</td><td>2007-01-01</td><td>2007-12-31</td><td>ST_CLERK</td><td>50</td>
    </tr>
   <tr><td>200</td><td>1995-09-17</td><td>2001-06-17</td><td>AD_ASST</td><td>90</td>
    </tr>
   <tr><td>176</td><td>2006-03-24</td><td>2006-12-31</td><td>SA_REP</td><td>80</td>
    </tr>
   <tr><td>176</td><td>2007-01-01</td><td>2007-12-31</td><td>SA_MAN</td><td>80</td>
    </tr>
   <tr><td>200</td><td>2002-07-01</td><td>2006-12-31</td><td>AC_ACCOUNT</td><td>90</td>
    </tr>
   <tr><td>1</td><td>2021-10-27</td><td>None value</td><td>None value</td><td>None value</td>
    </tr>
   </table>
</body>
</html>

```
