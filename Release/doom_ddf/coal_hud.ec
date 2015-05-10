//------------------------------------------
//  DOOM HUD CODE for EDGE
//  Copyright (c) 2009-2010 The Edge Team
//  Copyright (C) 1993-1996 by id Software, Inc.
//  Under the GNU General Public License
//------------------------------------------

var face_time  : float
var face_image : string


function doom_weapon_icon(slot, x, y, off_pic : string, on_pic : string) =
{
    if (player.has_weapon_slot(slot))
        hud.draw_image(x, y, on_pic)
    else
        hud.draw_image(x, y, off_pic)
}


function doom_key(x, y, card, skull,
    card_pic : string, skull_pic : string, both_pic : string) =
{
    var has_cd = player.has_key(card)
    var has_sk = player.has_key(skull)

    if (has_cd && has_sk)
    {
        hud.draw_image(x, y, both_pic)
    }
    else if (has_cd)
    {
        hud.draw_image(x, y, card_pic)
    }
    else if (has_sk)
    {
        hud.draw_image(x, y, skull_pic)
    }
}


function pain_digit() : string =
{
    var health = player.health()
    if (health > 100)
        health = 100

    var index = math.floor(4.99 * (100 - health) / 100)

    assert(index >= 0)
    assert(index <= 4)

    return "" + index
}

function turn_digit() : string =
{
/*
    //var r = math.floor(math.random() * 2.99)
    var r = math.floor(math.random() * 4.99)

    return "" + r
*/
    var r = math.random() * 2

    if (r < 0.34) return "0"
    if (r < 0.67) return "1"
    return "2"
}

function select_new_face() =
{
    // This routine handles the face states and their timing.
    // The precedence of expressions is:
    //
    //    dead > evil grin > turned head > straight ahead
    //

    // dead ?
    if (player.health() <= 0)
    {
        face_image = "STFDEAD0"
        face_time  = 10
        return
    }

    // evil grin when player just picked up a weapon
    if (player.is_grinning())
    {
        if (player.has_power(player.INVULN))
            face_image = "STFEVLG"
        else
        face_image = "STFEVL" + pain_digit()
        face_time  = 7
        return
    }

    // being attacked ?
    if (player.hurt_by())
    {
        if (player.hurt_pain() > 35)
        {
            face_image = "STFOUCH" + pain_digit()
            face_time = 26
            return
        }

        var dir = 0

        if (player.hurt_by() == "enemy" ||
            player.hurt_by() == "friend")
        {
            dir = player.hurt_dir()
        }

        if (dir < 0)
            face_image = "STFTL" + pain_digit() + "0"
        else if (dir > 0)
            face_image = "STFTR" + pain_digit() + "0"
        else
            face_image = "STFKILL" + pain_digit()

        face_time = 35
        return
    }

    // rampaging?
    if (player.is_rampaging())
    {
        face_image = "STFKILL" + pain_digit()
        face_time  = 7
        return
    }

    // god mode?
    if (player.has_power(player.INVULN))
    {
        face_image = "STFGOD0"
        face_time  = 7
        return
    }

    // default: look about the place...
    face_image = "STFST" + pain_digit() + turn_digit()
    face_time  = 17
}

function doomguy_face (x, y) =
{
    //---| doomguy_face |---

    face_time = face_time - hud.passed_time

    if (face_time <= 0)
        select_new_face()

    // FIXME faceback

    hud.draw_image(x - 1, y - 1, face_image)
}


function doom_overlay_status() = 
    {
    if (player.has_power(player.NIGHT_VIS))
        hud.draw_image(0, 0, "STVISOR")

    doomguy_face(0, 166)

if (player.has_key(1))
    hud.draw_image(  97, 170, "STKEYS0")

if (player.has_key(2))
    hud.draw_image(  97, 180, "STKEYS1")

if (player.has_key(3))
    hud.draw_image(  97, 190, "STKEYS2")

if (player.has_key(5))
    hud.draw_image(  107, 170, "STKEYS3")

if (player.has_key(6))
    hud.draw_image(  107, 180, "STKEYS4")

if (player.has_key(7))
    hud.draw_image(  107, 190, "STKEYS5")

    hud.set_alpha(0.7)
    hud.text_font("BIG_DIGIT")

    hud.draw_num2(78, 179, 3, player.health()) // 100

    hud.draw_image(  79, 179, "STTPRCNT")

    if (player.cur_weapon() == "PISTOL")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "DUAL_PISTOLS")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "SHOTGUN")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "SUPERSHOTGUN")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "CHAINGUN")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "MP40")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "ROCKET_LAUNCHER")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "PLASMA_RIFLE")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.cur_weapon() == "BFG9000")
    hud.draw_num2( 259, 179, 3, player.main_ammo(1))

    if (player.total_armor() > 100)
        hud.text_color(hud.BLUE)
    else
    if (player.total_armor() > 200)
        hud.text_color(hud.YELLOW)
    else
    if (player.total_armor() > 300)
        hud.text_color(hud.RED)
    else
        hud.text_color(hud.GREEN)

    hud.draw_num2(312, 179, 3, player.total_armor())

    hud.text_font("DOOM")
    hud.text_color(hud.WHITE)
    hud.draw_text(38, 170, "HEALTH")
    hud.draw_text(270, 170, "ARMOR")

    if (player.cur_weapon() == "PISTOL")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "DUAL_PISTOLS")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "SHOTGUN")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "SUPERSHOTGUN")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "CHAINGUN")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "MP40")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "ROCKET_LAUNCHER")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "PLASMA_RIFLE")
    hud.draw_text(220, 170, "AMMO")

    if (player.cur_weapon() == "BFG9000")
    hud.draw_text(220, 170, "AMMO")

}

function doom_automap() =
{
    // Background is already black, only need to use 'solid_box'
    // when we want a different color.
    //
    // hud.solid_box(0, 0, 320, 200 - 32, '80 80 80')

    hud.render_automap(0, 0, 320, 200)

    hud.text_font("DOOM")
    hud.draw_text(0, 200 - 32 - 10, hud.map_title())
    hud.draw_text(0, 200 - 32 - 10, hud.map_title())

        doom_overlay_status()
}


function edge_air_bar() =
{
    if (player.health() <= 0)
        return

    if (! player.under_water())
        return

    var air = player.air_in_lungs()

    air = math.floor(1 + 21 * ((100 - air) / 100.1))

    var barname : string;
    
    if (air < 10)
        barname = "AIRBAR0" + air
    else
        barname = "AIRBAR" + air

    hud.draw_image(0, 0, barname)
}


function begin_level() =
{
}

function draw_all() =
{
    hud.coord_sys(320, 200)
    hud.grab_times()

        hud.render_world(0, 0, 320, 200)

    if (hud.check_automap())
    {
       doom_automap()
        return
    }

        doom_overlay_status()

    edge_air_bar()
}
