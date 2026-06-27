package br.edu.atitus.apisample.services;



import br.edu.atitus.apisample.entities.User;
import br.edu.atitus.apisample.repositories.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.regex.Pattern;

@Service
public class UserService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    // Regex exigido: contém @ e dois ou mais domínios (ex: texto@dominio.com ou texto@dominio.com.br)
    private static final String EMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(?:\\.[a-zA-Z]{2,})*$";

    // Regex exigido: pelo menos uma letra maiúscula, uma minúscula e um número
    private static final String PASSWORD_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$";

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User save(User user) throws Exception {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new Exception("E-mail já cadastrado.");
        }

        // Validação do E-mail
        if (!Pattern.matches(EMAIL_REGEX, user.getEmail())) {
            throw new Exception("E-mail inválido! Deve conter @ e pelo menos dois segmentos de domínio (ex: gmail.com).");
        }

        // Validação da Senha
        if (!Pattern.matches(PASSWORD_REGEX, user.getPassword())) {
            throw new Exception("Senha insegura! Deve conter pelo menos uma letra maiúscula, uma minúscula e um número.");
        }

        // Criptografa a senha antes de salvar
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado com o e-mail: " + username));
    }
}
