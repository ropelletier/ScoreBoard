# ScoreBoard
ScoreBoard for OBS, WireCast and etc. for sport streaming on MacOS.


{::nomarkdown}
<html>
  <head>
    <link rel="stylesheet" href="style1.css">
  </head>
  <body>
    <h1>Contact me for ScoreBoard support.</h1>
<!--     <h1>Contact me for ScoreBoard support.</h1>
    <form action="https://formspree.io/f/xgernygo" method="POST">
      <input class="inputfield" type="email" name="_replyto" placeholder="Your e-mail *" required="required">
      <input class="inputfield" type="text" name="name" placeholder="Your name *" required="required"></input>
      <input class="inputfield" type="hidden" name="_subject" value="ScoreBoard support page from GitHub" />
      <textarea class="inputfield" name="message" rows="6" placeholder="Message text... *" required="required"></textarea>
      <button class="button" type="submit">Send</button>
    </form> -->
    
    
    <div id="form">
      <h1>Contact me for ScoreBoard support.</h1>
  <form method="POST" action="https://formspree.io/thiago.rossener@gmail.com"
        v-on:submit.prevent="validateBeforeSubmit" ref="contato">
    <fieldset>
      <input type="hidden" name="_subject" value="Novo contato!" />
      <input type="hidden" name="_next" value="https://www.rossener.com/contato/mensagem-enviada/" />
      <input type="hidden" name="_language" value="pt" />

      <input type="text" name="nome" placeholder="Seu nome" v-validate="'required'"
             :class="{ 'has-error': errors.has('nome') }">
      <span v-if="errors.has('nome')">${ errors.first('nome') }</span>

      <input type="text" name="email" placeholder="Seu e-mail" v-validate="'required|email'"
             :class="{ 'has-error': errors.has('nome') }">
      <span v-if="errors.has('email')">${ errors.first('email') }</span>

      <textarea name="mensagem" placeholder="Sua mensagem" v-validate="'required'"
                :class="{ 'has-error': errors.has('nome') }"></textarea>
      <span v-if="errors.has('mensagem')">${ errors.first('mensagem') }</span>

      <button type="submit">Enviar</button>
    </fieldset>
  </form>
</div>
</div>
  </body>
</html>
{:/nomarkdown}
