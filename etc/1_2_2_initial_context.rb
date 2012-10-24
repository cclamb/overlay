{
  # rs1 <-> ip-10-4-178-42
	'198.101.205.155_ec2-67-202-45-247.compute-1.amazonaws.com'	=> {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs1 <-> rs2
  '198.101.205.155_198.101.205.156' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs2 <-> rs3
  '198.101.205.156_198.101.203.202' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs2 <-> rs4
  '198.101.205.156_198.101.209.178' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs3 <-> rs7
  '198.101.203.202_198.101.207.34' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs3 <-> rs8
  '198.101.203.202_198.101.207.48' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs3 <-> rs9
  '198.101.203.202_198.101.207.236' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs4 <-> rs5
  '198.101.209.178_198.101.209.247' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # rs4 <-> rs6
  '198.101.209.178_198.101.202.188' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-4-178-42 <-> ip-10-196-115-185
  'ec2-67-202-45-247.compute-1.amazonaws.com_ec2-23-20-43-173.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-4-178-42 <-> ip-10-212-135-203
  'ec2-67-202-45-247.compute-1.amazonaws.com_ec2-23-22-68-94.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-196-115-185 <-> ip-10-114-61-53
  'ec2-23-20-43-173.compute-1.amazonaws.com_ec2-184-73-138-154.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-196-115-185 <-> ip-10-196-39-9
  'ec2-23-20-43-173.compute-1.amazonaws.com_ec2-107-20-47-98.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-196-115-185 <-> ip-10-203-83-56
  'ec2-23-20-43-173.compute-1.amazonaws.com_ec2-184-73-2-121.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-196-115-185 <-> ip-10-117-35-119
  'ec2-23-20-43-173.compute-1.amazonaws.com_ec2-23-22-144-216.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-212-135-203 <-> ip-10-99-65-6
  'ec2-23-22-68-94.compute-1.amazonaws.com_ec2-50-17-85-234.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-212-135-203 <-> ip-10-195-205-62
  'ec2-23-22-68-94.compute-1.amazonaws.com_ec2-50-17-57-243.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
  # ip-10-212-135-203 <-> ip-10-212-123-155
  'ec2-23-22-68-94.compute-1.amazonaws.com_ec2-50-16-141-176.compute-1.amazonaws.com' => {
    :sensitivity => :top_secret,
    :category => [:magenta]
  },
}