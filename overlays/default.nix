final: prev: {
  llvmPackages_11 = prev.recurseIntoAttrs (prev.callPackage ./llvm/11 ({
    inherit (prev.stdenvAdapters) overrideCC;
    buildLlvmTools = prev.buildPackages.llvmPackages_11.tools;
    targetLlvmLibraries = prev.targetPackages.llvmPackages_11.libraries or prev.llvmPackages_11.libraries;
    targetLlvm = prev.targetPackages.llvmPackages_11.llvm or prev.llvmPackages_11.llvm;
    stdenv = if prev.stdenv.cc.cc.isGNU or false then prev.gcc12Stdenv else prev.stdenv; # does not build with gcc13
  }));
}
