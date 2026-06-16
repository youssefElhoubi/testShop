<?php
// Initialize PrestaShop Core
require(dirname(__FILE__).'/config/config.inc.php');

echo "<h2 style='font-family:sans-serif;'>PrestaShop Module Diagnostics</h2><hr>";

$module_name = 'testpage';
$controller_file = 'view.php';
$class_name = 'TestpageViewModuleFrontController';

// Test 1: Is the module registered in the database?
echo "<h3>Test 1: Database Registration</h3>";
if (Module::isInstalled($module_name)) {
    echo "<p style='color:green; font-weight:bold;'>✅ PASS: Module '$module_name' is installed and active in the database.</p>";
} else {
    echo "<p style='color:red; font-weight:bold;'>❌ FAIL: Module '$module_name' is NOT recognized as installed by the database.</p>";
}

// Test 2: Does the file exist where it should?
echo "<h3>Test 2: File System Check</h3>";
$file_path = dirname(__FILE__)."/modules/$module_name/controllers/front/$controller_file";
if (file_exists($file_path)) {
    echo "<p style='color:green; font-weight:bold;'>✅ PASS: Controller file found exactly where it should be.</p>";
    echo "<p><small>Path: $file_path</small></p>";
} else {
    echo "<p style='color:red; font-weight:bold;'>❌ FAIL: Controller file NOT FOUND.</p>";
    echo "<p><small>Expected Path: $file_path</small></p>";
}

// Test 3: Can the core read your Class Name?
echo "<h3>Test 3: Class Name Verification</h3>";
if (file_exists($file_path)) {
    require_once($file_path);
    if (class_exists($class_name)) {
        echo "<p style='color:green; font-weight:bold;'>✅ PASS: Class '$class_name' is spelled correctly and can be loaded by the engine.</p>";
    } else {
        echo "<p style='color:red; font-weight:bold;'>❌ FAIL: The file exists, but PrestaShop cannot find the class '$class_name' inside it.</p>";
    }
} else {
    echo "<p style='color:gray;'>Skipping Test 3 because the file doesn't exist.</p>";
}
?>