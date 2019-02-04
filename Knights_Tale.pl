#!/usr/bin/perl -w

# ************************************************************
#  *                                                          
#  *  CSCI 680    Summer 2018  		                       
#  *                                                          
#  *  Programmer:  Usman Hussain							  
#															  
#  ***********************************************************

use strict;
use List::Util qw(min max sum);

#**************MAIN PROGRAM*****************
# *****This is the main program that runs the subroutines defined under it******
&driver;

# ******************************************************************
# SUBNAME=> driver
# ARGUMENTS=> @ARGV 
# RETURNS=> Nothing
# DESCRIPTION=> Used to kick off program and pass the values obtained
# via ARGS. 
# ******************************************************************
sub driver
{
  die "Must have 3 positive arguments in command line: $!" unless @ARGV==3;
  my $n = $ARGV[0];#size of board
  if ($n<=0)
    {
      $n=1;
    }
  my $N = $ARGV[1];#Max number of trials
  if ($N<=0)
    {
      $N=1;
    }
  my $F = $ARGV[2];#Number of print outs
  if ($F<=0)
    {
      $F=1;
    }  

    # print "$n, $N, $F";

  my $M = $N/$F; #Multiples by which prog will print

  srand(1);
  my @squaresTouched;

  for (my $t = 0; $t <= $N; $t++)
  {
  	push @squaresTouched, (&mvKnight(&getStart($n, $M, $t, $N)));	
  	if ($t==$N) {
  		&printResults($t,$N,@squaresTouched);
  	}
  }
  
}
# ******************************************************************
# SUBNAME=> printResults
# ARGUMENTS=> ($t,$N,@squaresTouched) passed from driver sub 
# RETURNS=> Nothing
# DESCRIPTION=> used to print the information after all the trials
# have been run.
# ******************************************************************

sub printResults
{

	my ($t,$N,@squaresTouched)=@_;
	my $min = min @squaresTouched;
	my $max = max @squaresTouched;
	my $amount = @squaresTouched;
	my $total= sum @squaresTouched;
	
  	my $average = $total/$amount;

  	if ($t==$N)
  	{
  		
	  	print "Total number of trials: $t \n";#
		print "Minimum number of squares touched: $min \n";
		print "Maximum number of squares touched: $max \n";
		printf "Average number of squares touched: %.2f \n",$average;
	}

}

# ******************************************************************
# SUBNAME=> getStart
# ARGUMENTS=> ($n, $M, $t, $N) passed from driver sub 
# RETURNS=> ($x,$y,$n,$t,$M,$N,@board) to mvKnight
# DESCRIPTION=> used to obtain a starting point and initialize
# a x and y coordinate on the board.
# ******************************************************************

sub getStart
{
    
  my ($n, $M, $t, $N) = @_;
    
  my $nSquared=$n*$n;

  my @board;
  while ($#board+1<$nSquared) 
  {
    push @board, 0;
  }
  
  my $initial= int(rand($nSquared-1));
   
  my $x = int($initial / $n);
  my $y = $initial % $n;

  #algorithm to find the index to make the current position true
  # columnNumber is always $n
  my $index = $y*$n+$x;

  $board[$index]=1;

  if ($t % $M == 0) 
	 {
		  # PRINTING 
		  print "Trail number: $t \n";
		  print "Random starting point ($x,$y) \n";
	 }

  
  return ($x,$y,$n,$t,$M,$N,@board);
 

}

# ******************************************************************
# SUBNAME=> mvKnight
# ARGUMENTS=> ($x,$y,$n,$t,$M,$N,@board) passed from getStart sub 
# RETURNS=> ($touchedCell) to list in driver sub
# DESCRIPTION=> used to move knight, if next move is on the board, 
# and then flip the index to the array to 1
# ******************************************************************
sub mvKnight
{
  my ($x,$y,$n,$t,$M,$N,@board)=@_;
	
  my @horz = qw /2 1 -1 -2 -2 -1 1 2/;
  my @vert = qw /-1 -2 -2 -1 1 2 2 1/;
  my $counter = 0;
  while ($counter<=7) 
  {
    # used to move knight
    $x+=$horz[$counter];
    $y+=$vert[$counter];
    

   
    # ****CONDITION TO SWITCH VALUE ON BOARD****
    my $index=0;#reset to orginal index value
    if (&nextMove($x,$y,$n)==1)
    {
      $index = ($n*$y)+$x;
      if ($board[$index]==1)
      {
      	next;
      }
      else
      {
  		  
	      $board[$index]=1;#setting the value at that index to true
	      ;
	      $counter=0;
  	  }
    }
    else
    {
    $x-=$horz[$counter];#reset to orginal coordinate
    $y-=$vert[$counter];#reset to orginal coordinate
    $counter++;
    }


  }

  # ******CONDITION TO COUNT TOUCHED CELLS****
  my $touchedCell=0;
  foreach my $element (@board)
  {
    if(int($element) eq 1)
    {
      $touchedCell++;
    }
  }

  if ($t % $M == 0)
  {
  print "Amount of squares touched is: $touchedCell \n \n";
  }

  return($touchedCell);

}

# ******************************************************************
# SUBNAME=> nextMove
# ARGUMENTS=> ($x,$y,$n) passed from mvKnight sub 
# RETURNS=> 1 or 0  to mvKnight 
# DESCRIPTION=> used to determin if coordinate will be on baord
# based on condition to validate
# ******************************************************************
  
sub nextMove #searchs for valid move based on algorthim
{
  my ($x,$y,$n)=@_;

  if ($x>($n-1)||$y>($n-1)||$x<0||$y<0)
  {
    return 0;
  }
  else
  {
    return 1;
  }
}

