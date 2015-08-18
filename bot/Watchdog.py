import json
import requests
import psutil
import time
import subprocess
import sys
import re

#Slack Token
url = "https://hooks.slack.com/services/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"


#PATHS MUST HAVE DOUBLE BACKSLASHED \\
program_data = {
        "dm_path" : 'E:\\Storage1\\BYOND\\bin\\dreammaker.exe',
        "dd_path" : 'E:\\Storage1\\BYOND\\bin\\dreamdaemon.exe',
        "dmb_path" :  'C:\\Users\\Jeremy\\Documents\\GitHub\\HippieStation13\\tgstation.dmb',
        "gs_path" : 'C:\\Users\\Jeremy\\AppData\\Local\\GitHub\\PortableGit_c2ba306e536fdf878271f7fe636a147ff37326ad\\bin\\sh.exe',
        "repo_path" : 'C:\\Users\\Jeremy\Documents\\GitHub\\HippieStation13',
        "dd_running" : False,
        "dd_called" : False,
        "update" : True,
        "dm_finished" : False,
        "request_timeout" : 1 # seconds
}

def run_iteration(data):

    def text_to_expression(string):
        temp =  re.findall(r'Updating ([^\.]+)\.\.(.+)', string)
        temp2 = str(temp).replace("\n","  ")
        if not temp2:
            temp2 = "TTE RETURNED NULL"
        return temp2
            
        

    def text_post_request(url, data):
        return post_request(url, {"text": data})

    def post_request(url, payload):
        return requests.post(url, data=json.dumps(payload), timeout=data["request_timeout"])

    def request_check(in_str, find_str, action):
        exists = in_str.find(find_str)
        if  exists == -1:
            return
        else:
            action()
            return exists


    
    def is_running(program_name):
        for p in psutil.process_iter():
            try:
                if p.name() == program_name:
                    print (program_name + " is running!")
                    return True
            except psutil.Error:
                pass
        return False #not found, go false

    #check to see if we need if we need to update
    #HELLO THIS ASSUMES THAT YOU HAVE OPENED GITHUBS CLIENT BEFORE AND YOU ARE ALREADY ON MASTER!
    proc = subprocess.Popen([data["gs_path"], '--login','-i'],  stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, cwd=data["repo_path"])
    stdout, stderr = proc.communicate("git pull".encode())
    std_str = str(stdout)
    commit_hash = text_to_expression(std_str)
    commit_hash = commit_hash.replace("\\n","  ")



    #Cool now lets compile since we updated!
    
         
    data["update"] = request_check(std_str, "Updating", lambda: text_post_request(url, "Update recived, updating commit from / to / file changes: " + commit_hash))
    print ("Updater was checked and returned")
    
    # Check to see if DD is running
    data["dd_running"] = is_running("dreamdaemon.exe")

    # Fuck DD isn't running lets fix that
    while not data["dd_running"] and not data["dm_finished"]:

        print(" Watchdog noticed that DD isnt running")
        r = text_post_request(url, "Something went wrong, server is restarting!");
        process = subprocess.Popen([data["dd_path"], data["dmb_path"]])
        data["dd_called"] = True
        print("DD called")
        r = text_post_request(url, "Server has been restarted! @crystalwarrior: fuck your cunt you shit eating cocksucker man eat a dong fucking mass ending shitfuck eat penis in your fuckface and shitout abortion of fuck and do shit in your ass you cock fuck shit monkey ass wanker from the depths of shit")
        break

    print(" Everything is ok, sleeping until next run (20 secs)")
    time.sleep(20)
    data["dd_running"] = False

#program starts here yes
while True:
    run_iteration(program_data)
            

