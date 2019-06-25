# Figures out which lines needs more annotators and
# which folders to work with

use Term::ANSIColor;

@classes=("USC430-S19", "USC430-F18", "CS495LC");
@folders=("intro", "buffer", "dns", "synflood");
$usage = "$0 intro|buffer|dns|synflood\n";
$who = "";

%annotations=();

sub print_milestones
{
    ($id, $folder, $class) = @_;
    print color("magenta"), "$id classified as $class\n";
    for $m (sort {$a <=> $b} keys %milestones)
    {
	print color("blue"), "\t\tMilestone $m  input ",  color("reset"), "$milestones{$m}{'input'}", color("blue"), " output ", color("reset"), " $milestones{$m}{'output'}";
    }
    print "\n";
    print "Press x if you agree with the classification or input new classification, press q to quit\n";
    open(my $fh, '>>', "annotations.txt");
    $input = <STDIN>;
    if ($input =~ /^[Xx]/)
    {
	print $fh  "$who $folder $id x\n";
    }
    elsif($input =~ /(M\d+|A\d+)+/)
    {
	print $fh "$who $folder $id $input";
    }
    elsif($input =~ /^U$/)
    {
	print $fh "$who $folder $id $input";
    }
    elsif($input =~ /^q/)
    {
	return 1;
    }
    else
    {
	print "Invalid input\n";
    }
    close($fh);
    return 0;
}

if ($#ARGV < 0)
{
    print $usage;
    exit(0);
}
# Load annotations
$fh = new IO::File("annotations.txt");
while(<$fh>)
{
    # sunshine USC430-S19/intro/milestones/ usc430al-intro-0 x
    @items = split /\s+/, $_;
    $annotations{$items[1] . "-" . $items[2]}{$items[0]} = 1;
}
open(WHO, "whoami|" );
$who = <WHO>;
$who =~ s/\n//g;
%mmet=();
%mattempted=();
%milestones=();
# Load milestones
$fh = new IO::File("milestones-" . $ARGV[0]);
$j = 0;
while(<$fh>)
{
    @items = split /\,/, $_;
    $milestones{$j}{'input'} = $items[1];
    $milestones{$j}{'output'} = $items[2];
    $mattempts{$j} = 0;
    %{$attempts{$j}} = ();
    $j++;
}
# Load user input
for $c (@classes)
{
    $dir = $c . "/" . $ARGV[0] . "/milestones";
    opendir(my $dh, $dir) || next;
    @files = readdir $dh;
    for $f (@files)
    {
	if ($f =~ /^\./)
	{
	    next;
	}
	$fh = new IO::File($dir . "/" . $f);
	$line = <$fh>;
	#User usc430ab start time 1548706268 end 1549309035
	@items = split /\s+/, $line;
	$uid = $items[1];
	<$fh>;
	$output = "";
	$input = "";
	$first = 1;
	while(<$fh>)
	{
	    if ($_ !~ /^INPUT/)
	    {
		$output .= $_;
	    }
	    else
	    {
		if (!$first)
		{
		    @elems = split /\|/, $input;
		    $id = $elems[1];
		    $class = $elems[2];
		    $cid = $dir . "-" . $id;
		    if (exists($annotations{$cid}) && exists($annotations{$cid}{$who}))
		    {
			$output = "";
			$input = $_;
			next;
		    }
		    print color("red"),$elems[5];
		    print "\n\n", color("green"), $elems[6] . $output, color("reset");
		    $r = print_milestones($id, $dir, $class);
		    if ($r == 1)
		    {
			exit(0);
		    }
		    $output = "";
		}
		$first = 0;
		$input = $_;
	    }
	}
	
	@elems = split /\|/, $input;
	$id = $elems[1];
	$class = $elems[2];
	$cid = $dir . "-" . $id;
	if (exists($annotations{$cid}) && exists($annotations{$cid}{$who}))
	{
	    next;
	}
	print color("red"),$elems[5];
	print "\n\n", color("green"), $elems[6] . $output, color("reset");
	$r = print_milestones($id, $dir, $class);
	if ($r == 1)
	{
	    exit(0);
	}
    }
}
