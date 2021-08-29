import bpy, json, os

INFO_FILE = "tron.json"
PREFIX_APP = "app"
PREFIX_LEVEL = "level"
PREFIX_WEAPON = "weapon"

basedir = os.path.dirname(bpy.data.filepath)
if not basedir:
    raise Exception("Blend file is not saved")

wrd = bpy.data.worlds['Arm']

# app = []
# level = []
# weapon = []
# for scene in bpy.data.scenes.items():
#     if bpy.data.scenes[scene[0]].arm_export:
#         if scene[0].startswith(PREFIX_APP+'.'):
#             app.append(scene[0][len(PREFIX_APP)+1:])
#         elif scene[0].startswith(PREFIX_LEVEL+'.'):
#             level.append(scene[0][len(PREFIX_LEVEL)+1:])
#         elif scene[0].startswith(PREFIX_WEAPON+'.'):
#             weapon.append(scene[0][len(PREFIX_WEAPON)+1:])

scenes = []
for scene in bpy.data.scenes.items():
    if bpy.data.scenes[scene[0]].arm_export:
       scenes.append(scene[0])

out = json.dumps({
    "name": wrd.arm_project_name,
    "version": wrd.arm_project_version,
    "pack": wrd.arm_project_package,
    "bundle": wrd.arm_project_bundle,
    "scenes": scenes,
    "runtime": wrd.arm_runtime,
    "root": wrd.arm_project_root,
    "armory": {
        "commit": wrd.arm_commit
    }
})
print('Exporting '+INFO_FILE)
print(out)
file = open(basedir+'/'+INFO_FILE,"w")
file.write(out)
file.close()
