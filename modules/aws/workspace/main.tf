data "aws_workspaces_bundle" "value_windows_10" {
  bundle_id = var.bundle_id
}

resource "aws_workspaces_workspace" "this" {
  directory_id = var.directory_id
  bundle_id    = data.aws_workspaces_bundle.value_windows_10.id
  user_name    = "creative"

  root_volume_encryption_enabled = false
  user_volume_encryption_enabled = false

  workspace_properties {
    compute_type_name                         = "VALUE"
    user_volume_size_gib                      = 50
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

  tags = merge({
    Department = "Backend Department"
    Team = "Team 1"
  },
  var.tags)

}
