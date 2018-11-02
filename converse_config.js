var ua = window.navigator.userAgent;
if (ua.indexOf('MSIE') >= 0 ||  ua.indexOf('Trident') >= 0) {
    alert('converse.js ist mit dem Internet Explorer nicht mehr lauffähig. Bitte nutzen Sie einen richtigen Browser.');
} else {
  var root_path = '/';
  var xmpp_domain = 'scholzbande.de';

  var converse_config = {
    authentication: 'login',
    auto_reconnect: true,
    bosh_service_url: 'https://xmpp.'+xmpp_domain+'/bosh/',
    muc_domain: 'conference.'+xmpp_domain,
    locked_domain: xmpp_domain,
    message_archiving: 'always',
    use_system_emojis: false,
    i18n: 'de',
    emoji_image_path: root_path+'twemoji/',
    allow_otr: false,
    allow_registration: false,
    message_carbons: true,
    muc_nickname_from_jid: true,
    show_desktop_notifications: 'all',
    notify_all_room_messages: true,
    notification_delay: 0,
    notification_icon: root_path+'dist/images/logo/new_launcher-web.png',
    play_sounds: true,
    sounds_path: root_path+'dist/sounds/',
    allow_chat_pending_contacts: true,
    allow_non_roster_messaging: true,
    auto_join_on_invite: true,
    roster_groups: false,
    show_controlbox_by_default: true,
    muc_respect_autojoin: false,
    muc_roomid_policy: /^[a-z0-9._-]{5,40}$/,
    muc_roomid_policy_hint: '<br><b>Namenskonvention für Gruppenchatnamen:</b><br>- mindestens 5 Zeichen, aber maximal 40 Zeichen,<br>- Kleinbuchstaben von a bis z (aber keine Umlaute) oder<br>- Zahlen oder<br>- Punkt (.) oder<br>- Unterstrich (_) oder<br>- Bindestrich (-),<br>- keine Leerzeichen<br>',
    allow_message_corrections: 'last',
    discover_connection_methods: false,
    whitelisted_plugins: ['download-dialog']
  };
}
