<?php

header('Content-Type: image/png');

require_once('sql.inc.php');

$db = new PDO('mysql:host='.$db_options['db.options']['host'].';dbname='.$db_options['db.options']['dbname'], $db_options['db.options']['user'], $db_options['db.options']['password'], array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\'')); 

$r = $db->query('select photo from cat where id_cat = '.addslashes($_GET['id_cat']));

$img = $r->fetch()['photo'];

echo $img;

?>