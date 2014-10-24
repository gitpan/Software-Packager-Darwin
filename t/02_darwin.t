# t/04_darwin.t; load Software::Packager and create a MacOS X package

$|++; 
my $test_number = 1;
use Software::Packager;
use Cwd;
use Config;
use File::Path;

if ($Config{'osname'} =~ /darwin/i)
{
	print "1..20\n";
}
else
{
	print "1..0\n";
	exit 0;
}

# test 1
my $packager = new Software::Packager();
$packager ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 2
$packager->package_name('MacOSXTestPackage');
my $package_name = $packager->package_name();
$package_name eq 'MacOSXTestPackage' ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 3
$packager->program_name('Software Packager');
my $program_name = $packager->program_name();
$program_name eq 'Software Packager' ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 4
$packager->description("This is a description");
my $description = $packager->description();
$description eq "This is a description" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 5
$packager->version('1.0.0');
my $version = $packager->version();
$version eq '1.0.0' ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 6
$packager->output_dir("t");
my $output_dir = $packager->output_dir();
$output_dir eq "t" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 7
$packager->category("Applications");
my $category = $packager->category();
$category eq "Applications" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 8
$packager->architecture("None");
my $architecture = $packager->architecture();
$architecture eq "None" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 9
$packager->icon("t/test_icon.tiff");
my $icon = $packager->icon();
$icon eq "t/test_icon.tiff" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 10
$packager->prerequisites("None");
my $prerequisites = $packager->prerequisites();
$prerequisites eq "None" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 11
$packager->vendor("Gondwanatech");
my $vendor = $packager->vendor();
$vendor eq "Gondwanatech" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 12
$packager->email_contact('rbdavison@cpan.org');
my $email_contact = $packager->email_contact();
$email_contact eq 'rbdavison@cpan.org' ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 13
$packager->creator('R Bernard Davison');
my $creator = $packager->creator();
$creator eq 'R Bernard Davison' ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 14
$packager->install_dir("perllib");
my $install_dir = $packager->install_dir();
$install_dir eq "perllib" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 15
$packager->tmp_dir("t/darwin_tmp_build_dir");
my $tmp_dir = $packager->tmp_dir();
$tmp_dir eq "t/darwin_tmp_build_dir" ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

# test 16
# so we have finished the configuration so add the objects.
open (MANIFEST, "< MANIFEST") or warn "Cannot open MANIFEST: $!\n";
my $add_status = 1;
my $cwd = getcwd();
while (<MANIFEST>)
{
	my $file = $_;
	chomp $file;
	my @stats = stat $file;
	my %data;
	$data{'TYPE'} = 'File';
	$data{'TYPE'} = 'Directory' if -d $file;
	$data{'SOURCE'} = "$cwd/$file";
	$data{'DESTINATION'} = $file;
	$data{'MODE'} = sprintf "%04o", $stats[2] & 07777;
	$add_status = undef unless $packager->add_item(%data);
}
$add_status ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;
close MANIFEST;

# test 17
my %hardlink;
$hardlink{'TYPE'} = 'Hardlink';
$hardlink{'SOURCE'} = "lib/Software/Packager/Darwin.pm";
$hardlink{'DESTINATION'} = "HardLink.pm";
if ($packager->add_item(%hardlink))
{
	print "ok $test_number\n";
}
else
{
	 print "not ok $test_number\n";
}
$test_number++;

# test 18
my %softlink;
$softlink{'TYPE'} = 'softlink';
$softlink{'SOURCE'} = "lib/Software";
$softlink{'DESTINATION'} = "SoftLink";
if ($packager->add_item(%softlink))
{
	print "ok $test_number\n";
}
else
{
	 print "not ok $test_number\n";
}
$test_number++;

# test 19
if ($packager->package())
{
	print "ok $test_number\n";
}
else
{
	print "not ok $test_number\n";
}
$test_number++;

# test 20
my $package_file = $packager->output_dir();
$package_file .= "/" . $packager->package_name();
$package_file .= ".pkg";
-d $package_file ? print "ok $test_number\n" : print "not ok $test_number\n";
$test_number++;

system("chmod -R 0777 $package_file");
rmtree($package_file, 1, 1);
