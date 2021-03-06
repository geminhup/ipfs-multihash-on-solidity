pragma solidity 0.4.25;

/**
 * @title IPFSStorage
 * @author Forest Fang (@saurfang)
 * @author geminhup (@geminhup)
 * @dev Stores IPFS (multihash) hash array by email. A multihash entry is in the format
 * of <varint hash function code><varint digest size in bytes><hash function output>
 * See https://github.com/multiformats/multihash
 *
 * Currently IPFS hash is 34 bytes long with first two segments represented as a single byte (uint8)
 * The digest is 32 bytes long and can be stored using bytes32 efficiently.
 */
contract IPFSStorage {
    struct Multihash {
        bytes32 digest;
        uint8 hashFunction;
        uint8 size;
    }

    mapping (string => Multihash[]) private entries;

    event EntrySet (
        string indexed email,
        bytes32 digest,
        uint8 hashFunction,
        uint8 size
    );

    /**
    * @dev associate a multihash entry with the sender address
    * @param _digest hash digest produced by hashing content using hash function
    * @param _hashFunction hashFunction code for the hash function used
    * @param _size length of the digest
    */
    function setEntry(string email, bytes32 _digest, uint8 _hashFunction, uint8 _size) public {
        Multihash memory entry = Multihash(_digest, _hashFunction, _size);
        entries[email].push(entry);
        emit EntrySet(email, _digest, _hashFunction, _size);
    }

    /**
    * @dev retrieve multihash entry associated with an address
    * @param _email email used as key
    */
    function getEntry(string _email, uint index) public view returns(bytes32 digest, uint8 hashfunction, uint8 size) {
        require(index < entries[_email].length, 'Invalid index');
        Multihash storage entry = entries[_email][index];
        return (entry.digest, entry.hashFunction, entry.size);
    }
}
