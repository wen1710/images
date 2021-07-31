-- 1.插入计次定义 t_bd_base_code
--   1.1 先备份  t_bd_base_code
select * into EYK6_MZMY..t_bd_base_code20210730 from EYK6_MZMY..t_bd_base_code
--   1.1 插入没有重复的code_id的项目
insert into
EYK6_MZMY..t_bd_base_code
(type_no,code_id,code_name)
select type_no,code_id,code_name
from EYXKX..t_bd_base_code 
where type_no='JC' 
and code_id not in (select code_id from EYK6_MZMY..t_bd_base_code where type_no='JC')
--   1.2 插入code_id有重复的项目并重新编号
insert into
EYK6_MZMY..t_bd_base_code
(type_no,code_id,code_name)
select type_no,'04',code_name
from EYXKX..t_bd_base_code 
where type_no='JC' 
  and code_id in (select code_id from EYK6_MZMY..t_bd_base_code where type_no='JC')
  
-- 2.导入计次方案
--  2.1 备份计次方案表 t_rm_vip_storedinfo
select * into EYK6_MZMY..t_rm_vip_storedinfo20210730 from EYK6_MZMY..t_rm_vip_storedinfo
--  2.2 将小卡熊的 t_rm_vip_storedinfo 导入命名为 t_rm_vip_storedinfo_xkx20210730
--  2.3 将导入的小卡熊 t_rm_vip_storedinfo 相同的计次定义编号修改为新的编号
-- 这里 server_id = t_bd_base_code.code_id 明志和小卡熊只有01编号相同 所以把小卡熊的01改成之前新设置的编号04
update EYK6_MZMY..t_rm_vip_storedinfo_xkx20210730
set server_id = '04'
where server_id = '01'
--  2.4 将 t_rm_vip_storedinfo_xkx20210730 的门店编码修改成和明志的一致
update EYK6_MZMY..t_rm_vip_storedinfo_xkx20210730
set branch_no = b.branch_no
from EYK6_MZMY..t_rm_vip_storedinfo_xkx20210730 a,EYK6_MZMY..t_bd_branch_info b
where a.branch_no = b.branch_man

-- 3.将小卡熊的计次方案插入明志
insert into t_rm_vip_storedinfo
(server_no, server_id, server_name, consum_amt,
consum_count, valid_days, branch_no, stored_flag,stop_flag, memo)
select server_no, server_id, server_name, consum_amt, consum_count, 
valid_days, branch_no, stored_flag, stop_flag, memo
from EYK6_MZMY..t_rm_vip_storedinfo_xkx20210730

-- 4.导入计次表
--  4.1 将小卡熊的计次表导入导小卡熊 dbo.t_rm_vip_stored_xkx20210731
--  4.2 备份明志的 t_rm_vip_stored
select * into EYK6_MZMY..t_rm_vip_stored20210730 from EYK6_MZMY..t_rm_vip_stored
--  4.3 将小卡熊导进来的表的门店修改为和新的一致
update EYK6_MZMY..t_rm_vip_stored_xkx20210731
set branch_no = b.branch_no
from EYK6_MZMY..t_rm_vip_stored_xkx20210731 a, EYK6_MZMY..t_bd_branch_info b
where a.branch_no = b.branch_man
--  4.4 将小卡熊的计次表导入明志
insert into EYK6_MZMY..t_rm_vip_stored(sheet_no, branch_no,  server_no,
server_type_code, tot_num, tot_money, real_money, fav_money,
 ret_amt, ret_num,sale_man, approve_flag, oper_id, oper_date,
 confirm_man, approve_date, cust_no, cust_name, valid_date, tel_no, card_id)
select sheet_no, branch_no,  server_no, server_type_code, tot_num, tot_money, 
real_money, fav_money, ret_amt, ret_num,sale_man, approve_flag, oper_id, oper_date,
 confirm_man, approve_date, cust_no, cust_name,valid_date, tel_no, card_id
 from EYK6_MZMY..t_rm_vip_stored_xkx20210731