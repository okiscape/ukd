if (typeof window.lightdm === 'undefined') {
  let authUser = null;
  window.lightdm = {
    users: [{ name: 'demo', display_name: 'Demo User' }],
    default_session: 'driftwm',
    can_shutdown: true,
    is_authenticated: false,
    authenticate: function (username) {
      authUser = username;
      setTimeout(function () {
        window.show_prompt && window.show_prompt('password:', 'password');
      }, 50);
    },
    respond: function (response) {
      setTimeout(function () {
        if (response === 'demo') {
          window.lightdm.is_authenticated = true;
        } else {
          window.lightdm.is_authenticated = false;
          window.show_message && window.show_message('incorrect password', 'error');
        }
        window.authentication_complete && window.authentication_complete();
      }, 50);
    },
    cancel_authentication: function () {},
    start_session: function (session) {
      console.log('[mock] start_session:', session);
    },
    shutdown: function () { console.log('[mock] shutdown'); }
  };
}

var lightdm = window.lightdm;

var clockEl = document.getElementById('clock');
var dateEl = document.getElementById('date');
var usernameInput = document.getElementById('username-input');
var passwordInput = document.getElementById('password-input');
var authZone = document.getElementById('auth-zone');
var messageEl = document.getElementById('message');
var shutdownBtn = document.getElementById('shutdown-btn');
var loginForm = document.getElementById('login-form');

var selectedSession = lightdm.default_session || '';
var awaitingPassword = false;
var authCompleted = false;
var isAuthenticating = false;
var pendingPassword = null;

function showAuthZone() {
  if (!isAuthenticating) return;
  if (authZone) authZone.style.display = 'flex';
  if (loginForm) loginForm.style.display = 'none';
  if (passwordInput) passwordInput.focus();
}

function resetToUsername() {
  authCompleted = false;
  awaitingPassword = false;
  pendingPassword = null;
  isAuthenticating = false;
  if (authZone) authZone.style.display = 'none';
  if (passwordInput) passwordInput.value = '';
  if (messageEl) messageEl.textContent = '';
  if (loginForm) loginForm.style.display = 'flex';
  if (usernameInput) {
    usernameInput.style.display = 'block';
    usernameInput.value = '';
    usernameInput.focus();
  }
  try { lightdm.cancel_authentication(); } catch (err) { }
  console.log("back to username")
}

window.show_prompt = function (text, type) {
  console.log("call: show prompt", text, type)
  if (!isAuthenticating) return;
  awaitingPassword = true;
  requestAnimationFrame(showAuthZone);
  if (pendingPassword !== null) {
    var pwd = pendingPassword;
    pendingPassword = null;
    awaitingPassword = false;
    lightdm.respond(pwd);
  }
};

window.show_message = function (text, type) {
  console.log("call: show message", text, type)
  if (messageEl) messageEl.textContent = text || '';
};

window.authentication_complete = function () {
  console.log("call: auth complete")
  if (!isAuthenticating || authCompleted) return;

  if (lightdm.is_authenticated) {
    authCompleted = true;
    if (messageEl) messageEl.textContent = '';
    lightdm.start_session(selectedSession);
  } else {
    var fpIcon = document.querySelector('.fp-icon');
    if (fpIcon) {
      fpIcon.classList.add('fp-shake');
      setTimeout(() => fpIcon.classList.remove('fp-shake'), 600);
    }

    awaitingPassword = true;
    pendingPassword = null;
    if (messageEl && !messageEl.textContent) {
      messageEl.textContent = 'incorrect password';
    }
    if (passwordInput) {
      passwordInput.value = '';
      passwordInput.focus();
    }
  }
};

window.autologin_timer_expired = function () {};

if (usernameInput) {
  usernameInput.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      startAuth();
      console.log("authentication: username entered")
    }
  });
}
function startAuth() {
  if (!usernameInput) return;
  console.log(usernameInput.value)
  var username = usernameInput.value.trim();

  const usernames = lightdm.users.map(i => i.username);

  if (!usernames.includes(username)) return;
  console.log("USERNAME IS IN ARRAY")

  if (messageEl) messageEl.textContent = '';

  isAuthenticating = true;
  pendingPassword = null;
  console.log("authentication: started")
  if (lightdm.is_authenticating) {
      try { lightdm.cancel_authentication(); } catch (err) {}
  }
  lightdm.authenticate(username);
  requestAnimationFrame(showAuthZone);
}

if (passwordInput) {
  passwordInput.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      resetToUsername();
      return;
    }

    if (e.key !== 'Enter') return;
    if (!isAuthenticating) return;

    var pwd = passwordInput.value;
    passwordInput.value = '';
    if (awaitingPassword) {
      awaitingPassword = false;
      lightdm.respond(pwd);
    } else {
      pendingPassword = pwd;
    }
  });
}

document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape' && authZone && authZone.style.display !== 'none') {
    resetToUsername();
  }
});

try {
  var MONTHS = ['january', 'february', 'march', 'april', 'may', 'june',
    'july', 'august', 'september', 'october', 'november', 'december'];

  function pad(n) { return n < 10 ? '0' + n : '' + n; }

  function tick() {
    var now = new Date();
    if (clockEl) {
      clockEl.textContent = pad(now.getHours()) + ':' + pad(now.getMinutes()) + ':' + pad(now.getSeconds());
    }
    if (dateEl) {
      dateEl.textContent = MONTHS[now.getMonth()] + ' ' + now.getDate() + ', ' + now.getFullYear();
    }
  }
  tick();
  setInterval(tick, 1000);

  if (shutdownBtn) {
    shutdownBtn.addEventListener('click', function () {
      if (lightdm.can_shutdown) lightdm.shutdown();
    });
  }
} catch (err) {
  console.error('[greeter]', err);
}

resetToUsername();
