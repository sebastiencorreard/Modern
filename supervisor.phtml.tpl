<!-- begin of $wims_theme/supervisor.phtml -->
!! supervisor page definition.
!nocache
!if $module!=home
 !exit
!endif
!set home_theme=yes

!readproc tabletheme

!read classlogo.phtml
!if $class_logo!=$empty
<img src="$class_logo" alt="logo" style="border:0px">
!endif
<p style="font-size:1.2em;text-align:center;">
    $wims_classname, $wims_institutionname
    <br>
    <small>($SU_log)</small>
</p>
<div class="wimsbody">

!if _tool isin $wims_session
  !read ./tools.phtml
  !goto end
!endif

!if $class_type isin 3
  $SU_greet.
  !read Subclasses1.phtml
  !if $class_typename=level
    <div class="wimscenter">
      !href module=adm/class/gateway $wims_name_SU_Gateway
    </div>
    !goto end
  !else
   !goto nocheck
  !endif
!endif class_type = 3

!if $class_type notin 13
  $SU_greet
  $SU_exp1
  !set d_=!char 7,8 of $class_expiration
  !set m_=!char 5,6 of $class_expiration
  !set y_=!char 1 to 4 of $class_expiration
  !read adm/date.phtml date,$y_,$m_,$d_
  !href module=adm/class/config $c_date_out
  $SU_exp2.
!else
  $SU_greet.
!endif

!set wims_ref_class=wims_button_help
!href target=wims_help module=help/main&chapter=3&open=3_sheet#sheet $wims_name_whelp

!if $wims_numpartconnected>0
  <p class="wims_connected">$SU_numpartconnected.</p>
!else
  <p>$SU_nopartconnected.</p>
!endif

!if $quota_free<2
  !if $quota_free<=0
    <div class="wims_msg alert">$wims_name_exceeded</div>
    <p class="wims_center">
      !set wims_ref_class=wims_button
      !href cmd=close&module=home&lang=$lang $wims_name_visitor
    </p>
    </div><!--wimsbody-->
    </div><!--wimspagebox-->
    !goto end
  !else
    <div class="wims_msg warning">
      <b>$wims_name_warning</b>! $wims_name_reaching_limit
    </div>
  !endif
!endif
:nocheck

!if & isin $newmsgcnt or $newmsgcnt>0
  <p class="wims_msg info">
  !href module=adm/forum/mboard $U_newmsg
  </p>
!endif
!if $class_type=4
   <div class="wimscenter">
    !href module=adm/class/gateway $wims_name_SU_Gateway
   </div>
  !goto end
!endif class_type=4

!if $class_type=2
  !if $subclasscnt>0
    $table_header
    $table_hdtr<th>$wims_name_number</th><th>$wims_name_title</th><th>$wims_name_nameteacher</th></tr>
    !for i=1 to $subclasscnt
      !let f_class=!record $i of wimshome/log/classes/$wims_class/.subclasses
      !let f_aff=!item 4 of $f_class
      !let f_name=!item 1 of $f_class
      $table_tr
       <td>$ADD_class $i</td>
       <td>
       !href module=adm/class/classes&type=authsupervisor&class=$f_name $f_aff
       </td>
       <td>
        !item 9 of $f_class
       </td>
      </tr>
    !next i
    $table_end
  !endif
  <div class="wimscenter">
   !read ./adm/oneitem.phtml addclass,1,module=adm/class/regclass
  </div>
  !goto end
!endif class_type=2
!! classtype != 2,3, 4
!let test=!fileexists wimshome/log/manager_msg.phtml.$lang
!if $test=yes
  <div id="wims_class_manager_msg" class="wims_class_manager_msg">
    !read ./wimshome/log/manager_msg.phtml.$lang
  </div>
!endif

!set test=!replace / by , in $wims_class
!if $(test[-1])=0
  !set test_up=!replace internal /0- by in $wims_class-
  !set wims_ref_class=wims_button
  !href module=adm/class/classes&type=authsupervisor&class=$test_up $SU_Bprogram
!endif

!set docpubliccnt=!recordcnt  wimshome/log/classes/$wims_class/doc/.docindex

!if $sheetcnt+$examcnt+$doccnt+$docpubliccnt+$votecnt+$subclasscnt+$freeworkcnt+$glossarycnt<=0
  <p>$SU_nosheet</p>
!else
  !if $seq_open=yes
   !set table_htdr_=$table_hdtr<th>$wims_name_number</th><th>$wims_name_title</th><th>$wims_name_sequence</th><th>$wims_name_Status</th><th>$wims_name_action</th></tr>
  !else
   !set table_htdr_=$table_hdtr<th>$wims_name_number</th><th>$wims_name_title</th><th>$wims_name_Status</th><th>$wims_name_action</th></tr>
  !endif
  $table_header
  <caption>$SU_shlist &nbsp; [
  !href module=adm/class/sequence $wims_name_reorder
  ] </caption>
  $table_htdr_
  !read themes/_widgets/supervisorsubclass.phtml
  !read themes/_widgets/supervisordoc.phtml
  !read themes/_widgets/supervisordocp.phtml
  !read themes/default/_widgets/supervisorsheet.phtml
  !read themes/default/_widgets/supervisorexam.phtml
  !read themes/_widgets/supervisorvote.phtml
  !read themes/_widgets/supervisortool.phtml
  !read themes/_widgets/supervisorfreework.phtml
  $table_end
!endif
$ADD_1
!href module=adm/doc&job=creat $ADD_doc
!if $wims_supertype!=4 or $class_typename!=class
  ,
  !href module=adm/class/sheet&sheet=$[$sheetcnt+1] $ADD_sheet
  ,
  !href module=adm/class/exam&exam=$[$examcnt+1] $ADD_exam
  ,
  !href module=adm/createxo $ADD_exo
!endif
!if $class_type=2
  ,
  !href module=adm/class/regclass $ADD_class
!endif

 $wims_name_or
!href module=adm/vote&job=creat $ADD_vote
.

!read ./form.phtml
!read ./result.phtml
!if $wims_supertype!=4 or $class_typename!=class
  <p>
  !href module=classes/$lang&special_parm=.nocache. $wims_name_classexo
  .&nbsp;
  !href module=adm/modtool Modtool
  .
  </p>
!endif
:end

<table style="background-color:$wims_ref_bgcolor;width:100%">
<tr><td style="text-align:left">
!if $class_typename notsametext program
  !href module=adm/class/userscore $wims_name_Score1
  &nbsp;
  !href module=adm/class/usermanage $wims_name_usermanage
!endif
<br>
!href module=adm/class/classes&type=supervisor $wims_name_U_oclass
<br>
!href cmd=close&module=home&lang=$lang $wims_name_visitor
</td><td style="text-align:center" >
!href style=student $wims_name_n_participant
<br>
!href module=adm/class/config $wims_name_SE_config
<br>
!href module=adm/class/config&job=security $wims_name_SE_secu
</td><td style="text-align:right">
!href target=wims_help module=help/main&chapter=3 $wims_name_help
<br>
!href module=adm/forum/mboard $wims_name_forum
!if $exist_cdt=yes
<br>
 !href module=adm/class/cdt $wims_name_cdt
 &nbsp; / &nbsp;
!endif
!href module=adm/class/freework $wims_name_Freeworks
 &nbsp; / &nbsp;
<br>
!href module=adm/class/motd $wims_name_SE_mod
<br>
</td>
</tr>
</table>
:end
<p style="text-align:center">
    <small>
    WIMS-$wims_version@$httpd_HTTP_HOST. $E_manager
    !mailurl $wims_site_manager\
    WIMS
    .
    </small>
</p>
</div>
</body>
</html>
<!-- end of $wims_theme/supervisor.phtml -->
