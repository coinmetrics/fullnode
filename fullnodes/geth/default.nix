{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "geth";
    inherit version;

    vendorSha256 = {
      "1.10.1" = "186zyqmvj39d3s2bgrah0nw4pcqwswvf7wrzx2krbm34k6z8w30f";
      "1.10.2" = "1idqrlj1as05s77hzzrjb7z1x6kg63wdn2iasc76b4jdbynp1fm8";
      "1.10.3" = "1q3mg0x9c3xh731pd5gf739nkq7jmbxhal8zxqh3lxslq51maf7k";
      "1.10.5" = "1nf2gamamlgr2sl5ibib5wai1pipj66xhbhnb4s4480j5pbv9a76";
      "1.10.6" = "1nf2gamamlgr2sl5ibib5wai1pipj66xhbhnb4s4480j5pbv9a76";
      "1.10.7" = "1cvsgrr1cwfm6lrmj14h9q0mj2r8rn7pxlbhcsppdzsvh3kfsn77";
      "1.10.8" = "1g6arc87crlgdn2gx8s6zpjf6ff7h51qwrcprq0zs4a4qm08mikv";
      "1.10.9" = "1ppwbz3yc7n870s5ndlyg8vrnl5c17n3j00cn8xzxdym01liqnln";
      "1.10.10" = "09ax84lp1q2bivnqs1imn3h13rjaj84a71b6766pb0v7vl04wqcb";
      "1.10.13" = "i2FOAN1ng3WNOWaFowiSSuYR4LA1Bo3tjkvgcClBXSU=";
      "1.10.14" = "i2FOAN1ng3WNOWaFowiSSuYR4LA1Bo3tjkvgcClBXSU=";
    }.${version} or (builtins.trace "Geth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/ethereum/go-ethereum.git";
      ref = "refs/tags/v${version}";
    };

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
