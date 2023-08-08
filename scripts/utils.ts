import { config as _config } from 'dotenv';
_config();

export function readEnvOrThrow(key: string): string {
    const value: string = process.env[key]!;
    if(value){
        return value
    }else{
        console.error(`The ${key}= must be populated in the .env`)
        process.exit(1);
    }
}