include {
  path = find_in_parent_folders()
}


terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/aws/ses///"
}

inputs = {
  emails = [
    "vserifoglu@creativeadvtech.com",
    "soyoun@creativeadvtech.com",
    "sdiab@creativeadvtech.com",
    "hraed@creativeadvtech.com",
    "sjasim@creativeadvtech.com",
    "broustaefarsi@creativeadvtech.com",
    "cnedelcu@creativeadvtech.com"
  ]
}
