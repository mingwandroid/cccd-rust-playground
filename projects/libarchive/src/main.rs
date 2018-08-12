extern crate libc;
extern crate os_type;

mod archive;

use std::fs::File;
use std::io::Read;
use archive::Archive;
use archive::ArchiveEntry;
use archive::Format;
use archive::FileType;
use os_type::OSType;

fn unpack(archive_file: &str, prefix: &str) {
    let mut f = File::open(archive_file).unwrap();
    let mut ent = Archive::open_archive(&mut f).unwrap().unwrap();

    let t = |e:&mut ArchiveEntry, path, size, ft, cont: &String| {
        println!("e.path(): {:?}", e.path());
        println!("path: {:?}", path);
        assert_eq!(e.format(), Format::Tar);
        assert_eq!(e.path(), path);
        assert_eq!(e.size(), size);
        assert_eq!(e.filetype(), ft);
        let mut contents = String::new();
        assert_eq!(e.read_to_string(&mut contents).unwrap(), size);
        assert_eq!(&contents, cont);
    };

    t(&mut ent, Some("bin"), 0, FileType::Directory, &"".to_string());

/*     let mut builder = reader::Builder::new();
    let mut reader = builder.open_file(archive_file).ok().unwrap();
    while reader.next_header().unwrap() {
        // let entry: &archive::Entry = &reader.entries;
        // println!("{:?}", entry.pathname());
        // println!("{:?}", entry.size());
        let file = entry as &archive::Entry;
        println!("{:?}", file.pathname());
        println!("{:?}", file.size());
    }
 */
}

fn main() {
    println!("Hello World!");

    match os_type::current_platform().os_type {
        OSType::OSX => unpack("/opt/conda/pkgs/python-3.7.0-hc167b69_0.tar.bz2", "/tmp"),
        OSType::Redhat | OSType::Ubuntu | OSType::Debian | OSType::Arch | OSType::CentOS => unpack("/opt/conda/pkgs/python-3.7.0-hc3d631a_0.tar.bz2", "/tmp"),
        OSType::Unknown => unpack("/opt/conda/pkgs/python-3.7.0-hc3d631a_0.tar.bz2", "/tmp"),
    }
}
