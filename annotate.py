import re
import os

path = "CS495LC/intro/" #directory with all the log files
milestoneFile = "milestones-intro" #path to milestones file

def main():
	ms = open(milestoneFile, "r") 

	m = [[],[]]

	for i, line in enumerate(ms): #loads milestones
		sec = line.split(",")
		m[0].append(re.compile(sec[1])) #compile all needed regex to array
		m[1].append(re.compile(sec[2].strip('\n')))	#set third argment as string, REMOVE NEWLINE FIRST 

	for logFile in os.listdir(path):
		if logFile.endswith(".log"):
			result = ["unmet"] * len(m[0]) #start with empty array 
			hist = open(path + logFile, "r") #could be any file really
			for line in hist: 
				sec = line.split(",")

				for i, idx in enumerate(m[0]):
					if m[0][i].match(sec[3]) is not None: #does regex match on input
						if len(m[1][i].findall(sec[4])) > 0:			 
							result[i] = "met"
						else:
							if result[i] == "unmet":
								result[i] = "attempted";
								print(m[1][i])

			hist.close()

			o = open("grades.txt", "a")
			o.write("grading student " + logFile.split("-")[0] + "\n")		
			for i, item in enumerate(result):
				o.write("milestone " + str(i) + " " + item + "\n")

			o.write("\n")
			o.close()

if __name__ == "__main__":
	main()